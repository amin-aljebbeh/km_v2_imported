import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import 'model/inventory_model.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<ProductData> productsListToActive = [];
  List<ProductData> productsListToInactive = [];
  List<ProductData> productsList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isError = false;

  bool displayToActiveProducts = true;

  _loadData({int filterIndex = 0}) async {
    setState(() {
      productsListToActive.clear();
      productsListToInactive.clear();
      productsList.clear();
      isLoading = true;
      isError = false;
    });
    try {
      var response = await ApiProvider.sendRequest(
        url: getInventoryProducts,
        method: HttpMethods.get,
      );
      if (response.statusCode == successCode && response.data["success"]) {
        productsListToActive.addAll(productsToReviewFromJson(jsonEncode(response.data)).productsToActivate);
        productsListToInactive.addAll(productsToReviewFromJson(jsonEncode(response.data)).productsToDeactivate);

        if (LoadingScreenServices.subWarehouses.isEmpty) await LoadingScreenServices.getSubWarehouse();
        productsList.clear();
        if (isActiveFilter == 0) {
          productsList = productsListToActive;
        } else if (isActiveFilter == 1) {
          productsList = productsListToInactive;
        } else {
          productsList = productsListToActive;
          productsList.addAll(productsListToInactive);
        }
        List<ProductData> sortedProductsList = Services.productListSort(productsList);
        productsList = sortedProductsList;
        if (filterIndex < warehouseFilter.length - 1) {
          productsList.removeWhere((data) => !warehouseFilter[filterIndex].hasMatch(data.supplierCode ?? "0"));
        }

        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Error While getting Inventory Products");
      Tools.logToConsole(e.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
      return false;
    }
  }

  final TextEditingController _controller = TextEditingController();
  String filter;
  int selectedSubWarehouseId;
  int filterProducts;
  int isActiveFilter;

  List<String> activeNotActive = [
    "بحاجة تفعيل",
    "بحاجة إيقاف تفعيل",
    "الجميع",
  ];

  List<RegExp> warehouseFilter = [
    // ignore: unnecessary_string_escapes
    RegExp("^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$"),
    RegExp(".*kh"),
    RegExp(".*br"),
    RegExp(".*kt"),
    RegExp(".*"),
  ];

  @override
  initState() {
    if (mounted) {
      super.initState();
    }

    selectedSubWarehouseId = LoadingScreenServices.subWarehouses[0].id;
    filterProducts = 0;
    isActiveFilter = 0;
    _loadData(filterIndex: filterProducts);

    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: InventorySearchTextField(
        onReload: () {
          _loadData(filterIndex: filterProducts);
        },
        controller: _controller,
        context: context,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: filterProducts,
                  items: Services.inventorySubWarehouseNames(),
                  onChanged: (value) {
                    setState(() {
                      productsList.clear();
                      filterProducts = value;
                      if (value != LoadingScreenServices.subWarehouses.length) {
                        selectedSubWarehouseId = LoadingScreenServices.subWarehouses[value].id;
                      } else {
                        selectedSubWarehouseId = -1;
                      }
                    });
                    _loadData(filterIndex: value);
                  },
                ),
                DropdownButton(
                  value: isActiveFilter,
                  items: Services.dropdownStringList(activeNotActive),
                  onChanged: (value) {
                    setState(() {
                      productsList.clear();
                      isActiveFilter = value;
                    });

                    _loadData(filterIndex: filterProducts);
                  },
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Loader(),
                  ),
                )
              : isError
                  ? Expanded(
                      child: Column(
                        children: [
                          AlertMessages(
                            text: StringUtils.errorMessage,
                            messageType: "internetError",
                            headerText: "حدث خطأ",
                          ),
                          ElevatedButton(
                            child: Text(
                              "المحاولة من جديد",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk),
                            ),
                            onPressed: () => _loadData(filterIndex: filterProducts),
                          ),
                        ],
                      ),
                    )
                  : productsList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: displayToActiveProducts
                                ? Text("لا يوجد منتجات بحاجة تفعيل",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk))
                                : Text("لا يوجد منتجات بحاجة إلغاء تفعيل",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk)),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: productsList == null ? 0 : productsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (filter == null ||
                                  filter == "" ||
                                  productsList[index].name.toLowerCase().contains(filter.toLowerCase())) {
                                if (selectedSubWarehouseId == -1 ||
                                    productsList[index].subWarehouseId == selectedSubWarehouseId) {
                                  String id, supplierCode;
                                  int isActive;
                                  bool attached;
                                  if (productsList[index].subWarehouseId != -1) {
                                    id = productsList[index].subWarehouseId.toString();
                                  } else {
                                    List<int> subWarehousesIds = LoadingScreenServices.subWarehouses
                                        .map((warehouse) => warehouse.id)
                                        .toList();
                                    List<int> productIds = productsList[index]
                                        .warehouses
                                        .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                        .toList();
                                    subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                    if (subWarehousesIds.isNotEmpty) {
                                      id = subWarehousesIds[0].toString();
                                    } else if (productsList[index].warehouses.isNotEmpty) {
                                      id = productsList[index].warehouses[0].pivot.subWarehouseId;
                                    }
                                  }
                                  if (productsList[index].supplierCode != null) {
                                    supplierCode = productsList[index].supplierCode;
                                  } else if (productsList[index].warehouses.isNotEmpty) {
                                    supplierCode = productsList[index]
                                        .warehouses
                                        .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                        .pivot
                                        .supplierCode;
                                  }
                                  if (productsList[index].isActive != 'null') {
                                    isActive = int.parse(productsList[index].isActive);
                                  } else if (productsList[index].warehouses.isNotEmpty) {
                                    isActive = int.parse(productsList[index].warehouses[0].pivot.isActive);
                                  }
                                  attached = false;
                                  if (productsList[index].supplierCode != 'null') {
                                    attached = true;
                                  } else if (productsList[index].warehouses != null) {
                                    if (productsList[index].warehouses.isNotEmpty) {
                                      attached = productsList[index]
                                          .warehouses
                                          .map((warehouse) => warehouse.pivot.supplierCode)
                                          .toList()
                                          .where((code) => code != 'null')
                                          .toList()
                                          .isNotEmpty;
                                    }
                                  }
                                  return InventoryProductsViewCard(
                                    index: 0,
                                    id: id,
                                    attached: attached,
                                    isActive: isActive,
                                    supplierCode: supplierCode,
                                    price: productsList[index].price != '0'
                                        ? productsList[index].price
                                        : productsList[index].warehouses.isNotEmpty
                                            ? productsList[index].warehouses[0].pivot.price
                                            : '0',
                                    scaffoldKey: scaffoldKey,
                                    fromInventory: true,
                                    productData: productsList[index],
                                    onChangeStatus: (result) {
                                      if (result) {
                                        setState(() {
                                          productsList.removeAt(index);
                                        });
                                      }
                                    },
                                    onDelete: (result) {
                                      if (result) {
                                        setState(() {
                                          productsList.removeAt(index);
                                        });
                                      }
                                    },
                                  );
                                }
                                return Container();
                              }
                              return Container();
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}

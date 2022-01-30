import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/core/api/api_importer.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'model/inventory_model.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<ProductData> productsListToActive = List<ProductData>();
  List<ProductData> productsListToInactive = List<ProductData>();
  List<ProductData> productsList = List<ProductData>();

  bool isLoading = false;
  bool isError = false;

  bool displayToActiveProducts = true;

  Future<bool> _loadData({int filterIndex = 0}) async {
    productsListToActive.clear();
    productsListToInactive.clear();
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_INVENTORY_PRODUCTS,
        method: httpMethods.get,
      );
      if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
        productsListToActive.addAll(productsToReviewFromJson(jsonEncode(response.data)).productsToActivate);
        productsListToInactive.addAll(productsToReviewFromJson(jsonEncode(response.data)).productsToDeactivate);

        if (LoadingScreenServices.subWarehouses.length == 0) await LoadingScreenServices.getSubWarehouse();
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
        productsList.removeWhere((data) => !warehouseFilter[filterIndex].hasMatch(data.supplierCode ?? "0"));

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

      setState(() {
        isLoading = false;
        isError = true;
      });
      return false;
    }
  }

  TextEditingController _controller = new TextEditingController();
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
    RegExp("^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$"),
    RegExp(".*kh"),
    RegExp(".*br"),
    RegExp(".*kt"),
    RegExp(".*"),
  ];

  @override
  initState() {
    if (this.mounted) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                  ),
              border: Border.all(color: ColorUtils.primaryColor, width: 2)),
          child: TextField(
            style: TextStyle(color: Colors.white, fontFamily: StringUtils.fontFamilyHKGrotesk),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.kmColors),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.kmColors),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.kmColors),
              ),
            ),
            cursorColor: ColorUtils.kmColors,
            controller: _controller,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {
                _loadData(filterIndex: filterProducts);
              },
              icon: Icon(
                Icons.refresh,
                size: 35,
              ),
            ),
          )
        ],
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
                      filterProducts = value;
                      if (value != LoadingScreenServices.subWarehouses.length)
                        selectedSubWarehouseId = LoadingScreenServices.subWarehouses[value].id;
                      else
                        selectedSubWarehouseId = -1;
                    });
                    _loadData(filterIndex: value);
                  },
                ),
                DropdownButton(
                  value: isActiveFilter,
                  items: Services.dropdownStringList(activeNotActive),
                  onChanged: (value) {
                    isActiveFilter = value;

                    _loadData(filterIndex: filterProducts);
                  },
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
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
                          RaisedButton(
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
                  : productsList.length == 0
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
                              var eachProduct = productsList[index];
                              if (filter == null ||
                                  filter == "" ||
                                  eachProduct.name.toLowerCase().contains(filter.toLowerCase())) {
                                if (selectedSubWarehouseId == -1 ||
                                    eachProduct.subWarehouseId == selectedSubWarehouseId) {
                                  return InventoryProductsViewCard(
                                    fromInventory: true,
                                    productData: eachProduct,
                                    onChangeStatus: (result) {
                                      if (result) {
                                        setState(() {
                                          productsList.removeAt(index);
                                        });
                                      }
                                    },
                                    active: int.parse(eachProduct.isActive),
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

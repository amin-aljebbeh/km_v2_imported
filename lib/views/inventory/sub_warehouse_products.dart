import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/inventory/services/inventory_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class SubWarehouseProducts extends StatefulWidget {
  final String subWarehouseId;

  SubWarehouseProducts({this.subWarehouseId});

  @override
  _SubWarehouseProductsState createState() => _SubWarehouseProductsState();
}

class _SubWarehouseProductsState extends State<SubWarehouseProducts> {
  List<ProductData> productsList = List<ProductData>();
  bool isLoading = false;
  bool isError = false;
  bool displayToActiveProducts = true;
  TextEditingController _controller = new TextEditingController();
  String filter;
  int filterProducts;
  int isActiveFilter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await InventoryServices.getSubWarehouseProducts(subWarehouseId: widget.subWarehouseId);
      if (response != null) {
        productsList.addAll(response);
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

  @override
  initState() {
    if (this.mounted) {
      super.initState();
    }
    _loadData();

    filterProducts = 0;
    isActiveFilter = 0;

    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
  }

  int filterIndex = 0; // 1 soft by not active // 2 sort as newer // 0 active first;

  _filterProducts() {
    if (filterIndex == 0) {
      // sort not active first
      setState(() {
        productsList.sort((a, b) {
          if (int.parse(a.isActive) == 0)
            return -1;
          else
            return 1;
        });
        filterIndex = 1;
      });
      Flushbar(
        backgroundColor: Colors.green,
        messageText: Text(
          "فرز حسب المواد الغير مفعلة",
          style: flushBarStyle,
        ),
        boxShadows: [
          BoxShadow(
            color: ColorUtils.primaryColor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: ColorUtils.kmColors,
      )..show(context);
    } else if (filterIndex == 1) {
      // Active first
      setState(() {
        productsList.sort((a, b) {
          if (int.parse(a.isActive) == 0)
            return 1;
          else
            return -1;
        });
        filterIndex = 2;
      });
      Flushbar(
        backgroundColor: Colors.green,
        messageText: Text(
          "فرز حسب المواد  المفعلة",
          style: flushBarStyle,
        ),
        boxShadows: [
          BoxShadow(
            color: ColorUtils.primaryColor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: ColorUtils.kmColors,
      )..show(context);
    } else if (filterIndex == 2) {
      // Oldest First
      setState(() {
        productsList.sort((a, b) {
          if (a.id > b.id)
            return -1;
          else if (a.id < b.id)
            return 1;
          else
            return 0;
        });
        filterIndex = 0;
      });

      Flushbar(
        backgroundColor: Colors.green,
        messageText: Text(
          "فرز حسب المواد المضافة حديثاً",
          style: flushBarStyle,
        ),
        boxShadows: [
          BoxShadow(
            color: ColorUtils.primaryColor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: ColorUtils.kmColors,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtils.primaryColor,
        onPressed: () {
          _filterProducts();
        },
        child: Icon(
          Icons.filter_list_rounded,
          size: 35,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: InventorySearchTextField(
        onReload: () {
          _loadData();
        },
        controller: _controller,
        context: context,
      ),
      body: Column(
        children: <Widget>[
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Loader(),
                  ),
                )
              : isError
                  ? Center(
                      child: Expanded(
                        child: Column(
                          children: [
                            AlertMessages(
                              text: StringUtils.errorMessage,
                              messageType: "internetError",
                              headerText: "حدث خطأ",
                            ),
                            RaisedButton(
                                child: Text(StringUtils.tryAgain, style: blackBold),
                                onPressed: () {
                                  _loadData();
                                }),
                          ],
                        ),
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
                            String id, supplierCode;
                            int isActive;
                            bool attached;
                            if (eachProduct.subWarehouseId != null)
                              id = eachProduct.subWarehouseId.toString();
                            else {
                              List<int> subWarehousesIds =
                                  LoadingScreenServices.subWarehouses.map((warehouse) => warehouse.id).toList();
                              List<int> productIds = eachProduct.warehouses
                                  .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                  .toList();
                              subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                              if (subWarehousesIds.length > 0)
                                id = subWarehousesIds[0].toString();
                              else if (eachProduct.warehouses.isNotEmpty)
                                id = eachProduct.warehouses[0].pivot.subWarehouseId;
                            }
                            if (eachProduct.supplierCode != null)
                              supplierCode = eachProduct.supplierCode;
                            else if (eachProduct.warehouses.isNotEmpty)
                              supplierCode = eachProduct.warehouses
                                  .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                  .pivot
                                  .supplierCode;
                            if (eachProduct.isActive != 'null') {
                              isActive = int.parse(eachProduct.isActive);
                            } else if (eachProduct.warehouses.isNotEmpty) {
                              isActive = int.parse(eachProduct.warehouses[0].pivot.isActive);
                            }
                            attached = false;
                            if (eachProduct.supplierCode != 'null')
                              attached = true;
                            else if (eachProduct.warehouses != null) if (eachProduct.warehouses.isNotEmpty) {
                              attached = eachProduct.warehouses
                                      .map((warehouse) => warehouse.pivot.supplierCode)
                                      .toList()
                                      .where((code) => code != 'null')
                                      .toList()
                                      .length >
                                  0;
                            }
                            return InventoryProductsViewCard(
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
                              fromInventory: false,
                              onDelete: (result) {
                                if (result) {
                                  setState(() {
                                    productsList.removeAt(index);
                                  });
                                }
                              },
                              productData: eachProduct,
                              onChangeStatus: (result) {
                                if (result) {
                                  setState(() {
                                    if (productsList[index].isActive == "1") {
                                      productsList[index].isActive = "0";
                                    } else {
                                      productsList[index].isActive = "1";
                                    }
                                  });
                                }
                              },
                            );
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

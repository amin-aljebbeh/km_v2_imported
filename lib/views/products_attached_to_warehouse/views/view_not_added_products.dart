import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

class NotAddedProductsToWarehouse extends StatefulWidget {
  @override
  _NotAddedProductsToWarehouseState createState() => _NotAddedProductsToWarehouseState();
}

class _NotAddedProductsToWarehouseState extends State<NotAddedProductsToWarehouse> {
  List<ProductData> productsList = List<ProductData>();
  bool isLoading = false;
  bool isError = false;
  TextEditingController _controller = new TextEditingController();
  String filter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    if (LoadingScreenServices.notAddedProducts.isNotEmpty) {
      productsList.addAll(LoadingScreenServices.notAddedProducts);
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        var response = await AddedProductsServices.getNotAddedProductsToWarehouse();
        if (response != null) {
          LoadingScreenServices.notAddedProducts.addAll(response);
          productsList.addAll(response);
          productsList.sort((a, b) {
            if (a.id > b.id) {
              return -1;
            } else if (a.id < b.id) return 1;
            return 0;
          });
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      } catch (e) {
        Tools.logToConsole("Error While getting Inventory Products");
        Tools.logToConsole(e.toString());
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    }
  }

  @override
  initState() {
    if (this.mounted) {
      super.initState();
    }
    _loadData();

    filter = '';
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
          LoadingScreenServices.notAddedProducts.clear();
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
                            RaisedButton(child: Text(StringUtils.tryAgain, style: blackBold), onPressed: () {}),
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
                              eachProduct.description.toLowerCase().contains(filter.toLowerCase())) {
                            String id, supplierCode;
                            int isActive;
                            bool attached;
                            if (productsList[index].subWarehouseId != -1)
                              id = productsList[index].subWarehouseId.toString();
                            else {
                              List<int> subWarehousesIds =
                                  LoadingScreenServices.subWarehouses.map((warehouse) => warehouse.id).toList();
                              List<int> productIds = productsList[index]
                                  .warehouses
                                  .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                  .toList();
                              subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                              if (subWarehousesIds.length > 0)
                                id = subWarehousesIds[0].toString();
                              else if (productsList[index].warehouses.isNotEmpty)
                                id = productsList[index].warehouses[0].pivot.subWarehouseId;
                            }
                            if (productsList[index].supplierCode != null)
                              supplierCode = productsList[index].supplierCode;
                            else if (productsList[index].warehouses.isNotEmpty)
                              supplierCode = productsList[index]
                                  .warehouses
                                  .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                  .pivot
                                  .supplierCode;
                            if (productsList[index].isActive != 'null') {
                              isActive = int.parse(productsList[index].isActive);
                            } else if (productsList[index].warehouses.isNotEmpty) {
                              isActive = int.parse(productsList[index].warehouses[0].pivot.isActive);
                            }
                            attached = false;
                            if (productsList[index].supplierCode != 'null')
                              attached = true;
                            else if (productsList[index].warehouses != null) if (productsList[index]
                                .warehouses
                                .isNotEmpty) {
                              attached = productsList[index]
                                      .warehouses
                                      .map((warehouse) => warehouse.pivot.supplierCode)
                                      .toList()
                                      .where((code) => code != 'null')
                                      .toList()
                                      .length >
                                  0;
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

import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class AddedProductsToWarehouse extends StatefulWidget {
  @override
  _AddedProductsToWarehouseState createState() => _AddedProductsToWarehouseState();
}

class _AddedProductsToWarehouseState extends State<AddedProductsToWarehouse> {
  List<ProductData> productsList = List<ProductData>();
  bool isLoading = false;
  bool isError = false;
  TextEditingController _controller = new TextEditingController();
  String filter;

  Future<bool> _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await AddedProductsServices.getAddedProductsToWarehouse();
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
                          try {
                            if (filter == null ||
                                filter == "" ||
                                eachProduct.description.toLowerCase().contains(filter.toLowerCase())) {
                              return InventoryProductsViewCard(
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
                          } catch (e) {}
                          return Container();
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

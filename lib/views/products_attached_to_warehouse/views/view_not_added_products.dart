import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class NotAddedProductsToWarehouse extends StatefulWidget {
  @override
  _NotAddedProductsToWarehouseState createState() => _NotAddedProductsToWarehouseState();
}

class _NotAddedProductsToWarehouseState extends State<NotAddedProductsToWarehouse> {
  List<ProductData> productsList = List<ProductData>();
  bool isLoading = false;
  bool isError = false;
  bool displayToActiveProducts = true;
  TextEditingController _controller = new TextEditingController();
  String filter;
  int filterProducts;
  int isActiveFilter;

  Future<bool> _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await AddedProductsServices.getNotAddedProductsToWarehouse();
      if (response != null) {
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
              _loadData();
            },
            icon: Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 35,
              ),
            ),
          )
        ],
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
                          return Container();
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

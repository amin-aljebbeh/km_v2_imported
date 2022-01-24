import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/inventory/services/inventory_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
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

  Future<bool> _loadData() async {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          //margin: const EdgeInsets.all(15.0),
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
              // _loadData();
              _filterProducts();
            },
            icon: Icon(
              Icons.filter_list_rounded,
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
                          return filter == null || filter == ""
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => () {},
                                  child: InventoryProductsViewCard(
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
                                    supplierCode: eachProduct.supplierCode,
                                    productId: eachProduct.id.toString(),
                                    active: int.parse(eachProduct.isActive),
                                    img: eachProduct.images.length > 0
                                        ? LoadingScreenServices.imagePrefixUrl +
                                            eachProduct.images[0].imageFileName
                                        : "",
                                    productName: eachProduct.name,
                                    quantity: eachProduct.unit.toString() != "null"
                                        ? eachProduct.quantity.toString() + " " + eachProduct.unit.toString()
                                        : eachProduct.quantity.toString(),
                                    price: int.parse(eachProduct.price.split(".")[0]),
                                    index: index,
                                  ),
                                )
                              : eachProduct.name.toLowerCase().contains(filter.toLowerCase())
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => () {},
                                      child: InventoryProductsViewCard(
                                        onDelete: (result) {
                                          if (result) {
                                            setState(() {
                                              productsList.removeAt(index);
                                            });
                                          }
                                        },
                                        productData: eachProduct,
                                        supplierCode: eachProduct.supplierCode,
                                        productId: eachProduct.id.toString(),
                                        active: int.parse(eachProduct.isActive),
                                        img: eachProduct.images.length > 0
                                            ? LoadingScreenServices.imagePrefixUrl +
                                                eachProduct.images[0].imageFileName
                                            : "",
                                        productName: eachProduct.name,
                                        quantity: eachProduct.unit.toString() != "null"
                                            ? eachProduct.quantity.toString() + " " + eachProduct.unit.toString()
                                            : eachProduct.quantity.toString(),
                                        price: int.parse(eachProduct.price.split(".")[0]),
                                        index: index,
                                      ),
                                    )
                                  : Container();
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

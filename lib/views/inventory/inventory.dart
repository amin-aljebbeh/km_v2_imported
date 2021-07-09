import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/products_view_widget.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

import 'model/inventory_model.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<ProductData> productsListToActive = List<ProductData>();
  List<ProductData> productsListToDeactive = List<ProductData>();
  List<ProductData> productsList = List<ProductData>();

  bool isLoading = false;
  bool isError = false;

  bool displayToActiveProducts = true;

  Future<bool> _loadData({int fillterIndex = 0}) async {
    productsListToActive.clear();
    productsListToDeactive.clear();
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
        productsListToActive.addAll(
            productsToReviewFromJson(jsonEncode(response.data))
                .productsToActivate);
        productsListToDeactive.addAll(
            productsToReviewFromJson(jsonEncode(response.data))
                .productsToDeactivate);
        if (isActiveFillter == 0) {
          productsList = productsListToActive;
        } else if (isActiveFillter == 1) {
          productsList = productsListToDeactive;
        } else {
          Tools.logToConsole("I'm in elase");
          Tools.logToConsole("$isActiveFillter");
          productsList = productsListToActive;
          // productsList.addAll(productsListToActive);
          productsList.addAll(productsListToDeactive);
        }

        productsList.removeWhere((data) =>
            !warehouseFillter[fillterIndex].hasMatch(data.supplierCode ?? "0"));

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
  int filterProducts;
  int isActiveFillter;

  List<String> activeNotActive = [
    "بحاجة تفعيل",
    "بحاجة إيقاف تفعيل",
    "الجميع",
  ];

  List<String> warehouseFilterName = [
    "بزروية",
    "محمصة",
    "الخضار",
    "المكتبة",
    "الجميع"
  ];

  List<RegExp> warehouseFillter = [
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

    filterProducts = 0;
    isActiveFillter = 0;
    _loadData(fillterIndex: filterProducts);

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
          //margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
                      10.0) //                 <--- border radius here
                  ),
              border: Border.all(
                  color: UtilsImporter().colorUtils.primarycolor, width: 2)),
          child: TextField(
            style: TextStyle(
                color: Colors.white,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: UtilsImporter().colorUtils.kmColors),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: UtilsImporter().colorUtils.kmColors),
              ),
              border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: UtilsImporter().colorUtils.kmColors),
              ),
            ),
            cursorColor: UtilsImporter().colorUtils.kmColors,
            controller: _controller,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              Flushbar(
                backgroundColor: Colors.red[800],
                // titleText: Text("تمت الإضافة بنجاح"),
                messageText: Text(
                  "ونحنا كمان منحبك",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                ),

                boxShadows: [
                  BoxShadow(
                    color: UtilsImporter().colorUtils.primarycolor,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  )
                ],
                icon: Icon(
                  Icons.favorite,
                  size: 28.0,
                  color: Colors.white,
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
              )..show(context);
            },
            icon: Icon(
              Icons.favorite,
              size: 35,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {
                _loadData(fillterIndex: filterProducts);
              },
              icon: Icon(
                Icons.refresh,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton(
                value: filterProducts,
                items: [
                  DropdownMenuItem<int>(
                    child: Text(
                      warehouseFilterName[0],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                    value: 0,
                  ),
                  DropdownMenuItem<int>(
                    child: Text(
                      warehouseFilterName[1],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    value: 1,
                  ),
                  DropdownMenuItem<int>(
                    child: Text(
                      warehouseFilterName[2],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    value: 2,
                  ),
                  DropdownMenuItem<int>(
                    child: Text(
                      warehouseFilterName[3],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    value: 3,
                  ),
                  DropdownMenuItem<int>(
                    child: Text(
                      warehouseFilterName[4],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    value: 4,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    filterProducts = value;
                  });
                  _loadData(fillterIndex: value);
                },
              ),
              DropdownButton(
                value: isActiveFillter,
                items: [
                  DropdownMenuItem<int>(
                    child: Text(
                      activeNotActive[0],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                    value: 0,
                  ),
                  DropdownMenuItem<int>(
                    child: Text(
                      activeNotActive[1],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    value: 1,
                  ),
                  DropdownMenuItem<int>(
                    child: Text(
                      activeNotActive[2],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    value: 2,
                  ),
                ],
                onChanged: (value) {
                  Tools.logToConsole("The Value is :$value");
                  isActiveFillter = value;
                  Tools.logToConsole("The fillterIndex is :$filterProducts");

                  _loadData(fillterIndex: filterProducts);
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
                ? Center(
                    child: Expanded(
                      child: Column(
                        children: [
                          AlertMessages(
                            text: "حدث خطأ أثناء محاولة جلب البيانات",
                            messageType: "internetError",
                            headerText: "حدث خطأ",
                          ),
                          RaisedButton(
                            child: Text("المحاولة من جديد",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                            onPressed: () =>
                                _loadData(fillterIndex: filterProducts),
                          ),
                        ],
                      ),
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
                                      fontFamily: UtilsImporter()
                                          .stringUtils
                                          .HKGrotesk))
                              : Text("لا يوجد منتجات بحاجة إلغاء تفعيل",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: UtilsImporter()
                                          .stringUtils
                                          .HKGrotesk)),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount:
                              productsList == null ? 0 : productsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var eachProduct = productsList[index];
                            return filter == null || filter == ""
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => () {},
                                    child: ProductsViewCard(
                                      fromInventory: true,
                                      productData: eachProduct,
                                      onChangeStatus: (result) {
                                        if (result) {
                                          Tools.logToConsole(
                                              "the result : $result");
                                          setState(() {
                                            productsList.removeAt(index);
                                          });
                                        }
                                      },
                                      supplierCode: eachProduct.supplierCode,
                                      productId: eachProduct.id.toString(),
                                      active: int.parse(eachProduct.isActive),
                                      img: eachProduct.images.length > 0
                                          ? LoadingScreenServices
                                                  .imagePrefixUrl +
                                              eachProduct
                                                  .images[0].imageFileName
                                          : "",
                                      product_name: eachProduct.name,
                                      quantity: eachProduct.unit.toString() !=
                                              "null"
                                          ? eachProduct.quantity.toString() +
                                              " " +
                                              eachProduct.unit.toString()
                                          : eachProduct.quantity.toString(),
                                      price: int.parse(
                                          eachProduct.price.split(".")[0]),
                                      index: index,
                                    ),
                                  )
                                : eachProduct.name
                                        .toLowerCase()
                                        .contains(filter.toLowerCase())
                                    ? GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () => () {},
                                        child: ProductsViewCard(
                                          fromInventory: true,
                                          productData: eachProduct,
                                          supplierCode:
                                              eachProduct.supplierCode,
                                          productId: eachProduct.id.toString(),
                                          active:
                                              int.parse(eachProduct.isActive),
                                          img: eachProduct.images.length > 0
                                              ? LoadingScreenServices
                                                      .imagePrefixUrl +
                                                  eachProduct
                                                      .images[0].imageFileName
                                              : "",
                                          product_name: eachProduct.name,
                                          quantity: eachProduct.unit
                                                      .toString() !=
                                                  "null"
                                              ? eachProduct.quantity
                                                      .toString() +
                                                  " " +
                                                  eachProduct.unit.toString()
                                              : eachProduct.quantity.toString(),
                                          price: int.parse(
                                              eachProduct.price.split(".")[0]),
                                          index: index,
                                        ),
                                      )
                                    : Container();
                          },
                        ),
                      ),
      ]),
    );
  }
}

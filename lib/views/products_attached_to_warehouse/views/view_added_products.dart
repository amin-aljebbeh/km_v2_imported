import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/products_view_widget.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';

class AddedProductsToWarehouse extends StatefulWidget {
  @override
  _AddedProductsToWarehouseState createState() =>
      _AddedProductsToWarehouseState();
}

class _AddedProductsToWarehouseState extends State<AddedProductsToWarehouse> {
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

    filterProducts = 0;
    isActiveFilter = 0;

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
                  color: UtilsImporter().colorUtils.primaryColor, width: 2)),
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
                              text: "حدث خطأ أثناء محاولة جلب البيانات",
                              messageType: "internetError",
                              headerText: "حدث خطأ",
                            ),
                            RaisedButton(
                                child: Text("المحاولة من جديد",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk)),
                                onPressed: () {
                                  _loadData();
                                }),
                          ],
                        ),
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
                                          if (productsList[index].isActive ==
                                              "1") {
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
                                    quantity:
                                        eachProduct.unit.toString() != "null"
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
                                            ? LoadingScreenServices
                                                    .imagePrefixUrl +
                                                eachProduct
                                                    .images[0].imageFileName
                                            : "",
                                        productName: eachProduct.name,
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
                                  : Container();
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

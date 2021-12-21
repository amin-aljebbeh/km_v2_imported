import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/products_view_widget.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/prices_changes/services/prices_changes_services.dart';
import 'model/prices_changes_model.dart';

class Prices extends StatefulWidget {
  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  TextEditingController _controller = new TextEditingController();
  bool isLoading;
  bool isError;
  String filter;
  PricesChanges productsList;
  int numberOfProducts;
  _loadData() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    productsList = await PricesChangesServices.loadData();

    if (productsList != null) {
      setState(() {
        isLoading = false;
        isError = false;
        numberOfProducts = productsList.count;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    numberOfProducts = 0;
    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
    _loadData();
    super.initState();
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
            child: Text(
              "$numberOfProducts",
              style: TextStyle(fontSize: 20),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {
                _loadData();
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
                              onPressed: () => _loadData(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : productsList.count == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Text("لايجود منتجات تغير سعرها اليوم",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: productsList == null
                                ? 0
                                : productsList.prouctsPriceChange.length,
                            itemBuilder: (BuildContext context, int index) {
                              var eachProduct =
                                  productsList.prouctsPriceChange[index];
                              return filter == null || filter == ""
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => () {},
                                      child: ProductsViewCard(
                                        productData: eachProduct,
                                        oldPrice: int.parse(eachProduct.price
                                                .split(".")[0]) -
                                            int.parse(eachProduct.priceChange
                                                .toString()
                                                .split(".")[0]),
                                        supplierCode: eachProduct.supplierCode,
                                        productId: eachProduct.id.toString(),
                                        img: eachProduct.images.length > 0
                                            ? LoadingScreenServices
                                                    .imagePrefixUrl +
                                                eachProduct
                                                    .images[0].imageFileName
                                            : "",
                                        productName: eachProduct.name,
                                        active: int.parse(eachProduct.isActive),
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
                                            productData: eachProduct,
                                            oldPrice: int.parse(eachProduct
                                                    .price
                                                    .split(".")[0]) -
                                                int.parse(eachProduct
                                                    .priceChange
                                                    .toString()
                                                    .split(".")[0]),
                                            supplierCode:
                                                eachProduct.supplierCode,
                                            productId:
                                                eachProduct.id.toString(),
                                            img: eachProduct.images.length > 0
                                                ? LoadingScreenServices
                                                        .imagePrefixUrl +
                                                    eachProduct
                                                        .images[0].imageFileName
                                                : "",
                                            productName: eachProduct.name,
                                            active:
                                                int.parse(eachProduct.isActive),
                                            quantity: eachProduct.unit
                                                        .toString() !=
                                                    "null"
                                                ? eachProduct.quantity
                                                        .toString() +
                                                    " " +
                                                    eachProduct.unit.toString()
                                                : eachProduct.quantity
                                                    .toString(),
                                            price: int.parse(eachProduct.price
                                                .split(".")[0]),
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

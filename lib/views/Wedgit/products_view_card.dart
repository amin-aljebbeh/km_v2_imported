import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

class ProductsViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int index;
  int active;
  final String productId;
  final String supplierCode;
  final ProductData productData;
  final int subWarehouseId;

  ProductsViewCard({
    this.img,
    this.productName,
    this.quantity,
    this.price,
    this.index,
    this.productId,
    this.supplierCode,
    this.productData,
    this.active,
    @required this.subWarehouseId,
  });

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  bool addedToCart = false;

  Future<bool> updateStatus(String productId, String statusId) async {
    var response = await ProductsServices.updateProductsDetails(
        bodyKey: "is_active",
        value: statusId,
        subWarehouseId: widget.productData.subWarehouseId.toString(),
        isForSubWarehouse: true,
        productId: widget.productId);

    if (response) {
      Flushbar(
        backgroundColor: Colors.green,
        // titleText: Text("تمت الإضافة بنجاح"),
        messageText: Text(
          "تم التعديل بنجاح",
          style: flushBarStyle,
        ),

        boxShadows: [
          BoxShadow(
            color: UtilsImporter().colorUtils.primarycolor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.assignment_turned_in,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 1),
        leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      return true;
    } else {
      Flushbar(
        backgroundColor: Colors.red[900],
        messageText: Text(
          "فشل في العملية يرجى المحاولة من جديد",
          style: flushBarStyle,
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.red,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.close,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Tools.logToConsole(
        "SUBWAREHOUSE ${LoadingScreenServices.subWarehouses[0]}     ${widget.subWarehouseId}");
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(Radius.circular(20.0))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                        tag: widget.index + 100,
                        child: Image(
                          // fadeInCurve: Curves.fastOutSlowIn,
                          // placeholder: AssetImage("assets/kmIcon.png"),
                          fit: BoxFit.contain,
                          image: widget.img.length > 0
                              ? AdvImageCache(
                                  widget.img,
                                  useMemCache: true,
                                  diskCacheExpire: Duration(days: 400),
                                )
                              : AssetImage("assets/kmIcon.png"),
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                        ),
                      )),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Text(
                                widget.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.quantity,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: UtilsImporter().colorUtils.greycolor,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                              UtilsImporter()
                                      .stringUtils
                                      .oCcy
                                      .format(widget.price)
                                      .toString() +
                                  " ${LoadingScreenServices.companyInformation.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )),
                LoadingScreenServices.subWarehouses
                        .any((element) => element.id == widget.subWarehouseId)
                    ? Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                    10.0) //                 <--- border radius here
                                ),
                            border: Border.all(
                                color: UtilsImporter().colorUtils.primarycolor,
                                width: 2)),
                        child: Center(
                          child: Column(
                            children: [
                              Switch(
                                value: widget.active == 1 ? true : false,
                                onChanged: (value) {
                                  if (widget.active == 1) {
                                    updateStatus(widget.productId, "0");
                                  } else {
                                    updateStatus(widget.productId, "1");
                                  }
                                  setState(() {
                                    if (widget.active == 1) {
                                      widget.active = 0;
                                    } else {
                                      widget.active = 1;
                                    }
                                  });
                                },
                                activeTrackColor:
                                    UtilsImporter().colorUtils.kmColors2,
                                activeColor:
                                    UtilsImporter().colorUtils.kmColors,
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
        // SizedBox(height: 4),
        //  Divider()
      ),
    );
  }
}

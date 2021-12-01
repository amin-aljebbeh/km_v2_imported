// import 'package:cache_image/cache_image.dart';
import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/views/add_products_to_sub_warehouse.dart';
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
  Function(bool) onChangeStatus;
  final int oldPrice;
  final bool attached;
  final ProductData productData;
  final Function(bool) onDelete;
  final bool fromInventory;

  ProductsViewCard(
      {this.img,
      this.productName,
      this.quantity,
      this.price,
      this.index,
      this.productId,
      this.supplierCode,
      this.onChangeStatus,
      this.oldPrice,
      this.active,
      this.productData,
      this.onDelete,
      this.fromInventory = false,
      this.attached = true});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  _unAttcahProduct() async {
    bool response = await AddedProductsServices.unAttcahProductsToSubWarehouse(
        productsId: widget.productId,
        subWarehouse: widget.productData.subWarehouseId.toString());
    if (response) {
      widget.onDelete(true);
      _successFlushBar();
    } else {
      _errorFlushBar();
    }
  }

  _errorFlushBar() {
    return Flushbar(
      backgroundColor: Colors.red[900],
      messageText: Text(
        "فشل في العملية يرجى المحاولة من جديد",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
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
      duration: Duration(seconds: 2),
      // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
    )..show(context);
  }

  _successFlushBar() {
    return Flushbar(
      backgroundColor: Colors.green,
      // titleText: Text("تمت الإضافة بنجاح"),
      messageText: Text(
        "تمت العملية بنجاح",
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
        Icons.assignment_turned_in,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 1),
      leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
    )..show(context);
  }

  void _showDialogDeleteProducts(
      {@required String productsId, @required String productsName}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "حذف منتج من المستودع",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          content: Text(
            "هل أنت متأكد أنك تريد إزالة $productsName من المستودع",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "نعم",
                style: TextStyle(
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                ),
              ),
              onPressed: () {
                _unAttcahProduct();
                Tools.logToConsole("The Product ID: $productsId");
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "إلغاء",
                style: TextStyle(
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.productData != null &&
                widget.productData.supplierCode != null)
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ProductDetailView(
                            product: widget.productData,
                            isFromFavoriteScreen: false,
                          )));
            Tools.logToConsole("Products Data is null");
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                thickness: 0.8,
                color: Colors.grey[800],
              ),
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
                            tag: widget.productId,
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
                            ))),
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
                            Wrap(
                              children: [
                                widget.price != null
                                    ? Text(
                                        UtilsImporter()
                                                .stringUtils
                                                .oCcy
                                                .format(widget.price)
                                                .toString() +
                                            "  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: UtilsImporter()
                                                .colorUtils
                                                .primarycolor,
                                            fontFamily: UtilsImporter()
                                                .stringUtils
                                                .HKGrotesk,
                                            fontSize: 18))
                                    : Container(),
                                widget.oldPrice != null
                                    ? RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                              text: UtilsImporter()
                                                  .stringUtils
                                                  .oCcy
                                                  .format(widget.oldPrice)
                                                  .toString(),
                                              style: new TextStyle(
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Container(
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
                          widget.supplierCode != null &&
                                  LoadingScreenServices.subSupplierCodeHint
                                      .hasMatch(widget.supplierCode) &&
                                  widget.active != null
                              ? Switch(
                                  value: widget.active == 1 ? true : false,
                                  onChanged: (value) async {
                                    setState(() {
                                      if (widget.active == 1) {
                                        widget.active = 0;
                                      } else {
                                        widget.active = 1;
                                      }
                                    });
                                    bool result;

                                    result = await ProductsServices
                                        .updateProductsDetails(
                                            bodyKey: "is_active",
                                            value: value ? "1" : "0",
                                            subWarehouseId: widget
                                                .productData.subWarehouseId
                                                .toString(),
                                            isForSubWarehouse: true,
                                            productId: widget.productData.id
                                                .toString());

                                    if (result) {
                                      widget.onChangeStatus(true);
                                      _successFlushBar();
                                    } else {
                                      _errorFlushBar();
                                      setState(() {
                                        if (widget.active == 1) {
                                          widget.active = 0;
                                        } else {
                                          widget.active = 1;
                                        }
                                      });
                                    }
                                  },
                                  activeTrackColor:
                                      UtilsImporter().colorUtils.kmColors2,
                                  activeColor:
                                      UtilsImporter().colorUtils.kmColors,
                                )
                              : Container(),
                          widget.attached &&
                                  widget.supplierCode != null &&
                                  !widget.fromInventory
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_sharp,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _showDialogDeleteProducts(
                                        productsId: widget.productId,
                                        productsName: widget.productName);
                                  })
                              : !widget.fromInventory
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new AddProductsToSubWarehouse(
                                                      productData:
                                                          widget.productData,
                                                    )));
                                      })
                                  : IconButton(
                                      icon: Icon(
                                        Icons.check_sharp,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        bool result = await ProductsServices
                                            .updateProductsDetails(
                                                bodyKey:
                                                    "under_check_availability",
                                                value: "0",
                                                isForSubWarehouse: true,
                                                subWarehouseId: widget
                                                    .productData.subWarehouseId
                                                    .toString(),
                                                productId: widget.productData.id
                                                    .toString());

                                        if (result) {
                                          widget.onChangeStatus(true);
                                          _successFlushBar();
                                        } else {
                                          _errorFlushBar();
                                        }
                                      })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../../utils/Styles.dart';
import 'package:kammun_app/utils/colors_utils.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/full_screen_image.dart';
import 'package:kammun_app/views/order_details/services/order_details_services.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

class OrderDetailViewMainCard extends StatefulWidget {
  final String img;
  final String productName;
  String quantity;
  final int price;
  final int index;
  final String unit;
  final String productCount;
  int active;
  final String productId;
  final String supplierCode;
  final OrderProducts productsData;
  int subWarehouseId;
  final int orderId;

  Function(int) onCheckbox;

  OrderDetailViewMainCard(
      {this.img,
      this.productName,
      this.quantity,
      this.price,
      this.index,
      this.unit,
      this.active,
      this.productCount,
      this.supplierCode,
      this.productId,
      this.productsData,
      this.onCheckbox,
      @required this.orderId,
      @required this.subWarehouseId});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewMainCardState();
  }
}

class OrderDetailViewMainCardState extends State<OrderDetailViewMainCard> {
  int noOfOrders = 1;
  Color borderColor = Colors.transparent;
  Color checkboxColor = Colors.blue;
  bool editProductQuantity = false;
  List<DropdownMenuItem> subWarehouseList = [];

  @override
  void initState() {
    for (int i = 0; i < LoadingScreenServices.swbWarehouses.length; i++) {
      subWarehouseList.add(DropdownMenuItem(
        child: AutoSizeText(
          LoadingScreenServices.swbWarehouses[i].name,
          overflow: TextOverflow.fade,
          maxLines: 1,
          maxFontSize: 15,
          style: mainStyle,
        ),
        value: LoadingScreenServices.swbWarehouses[i].id,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Tools.logToConsole(widget.supplierCode);
    if (widget.subWarehouseId == 2 || widget.subWarehouseId == 6) {
      borderColor = ColorUtils().khawajaColor;
    } else if (widget.subWarehouseId == 3) {
      borderColor = ColorUtils().vegtableColor;
    } else if (widget.subWarehouseId == 4) {
      borderColor = ColorUtils().libraryColor;
    } else if (widget.subWarehouseId == 7) {
      borderColor = ColorUtils().meetColor;
    } else if (widget.subWarehouseId == 8) {
      borderColor = ColorUtils().pharmaColor;
    } else if (widget.subWarehouseId == 9) {
      borderColor = ColorUtils().amourColor;
    } else {
      borderColor = Colors.transparent;
    }

    return Container(
      padding: EdgeInsets.only(
        top: 10,
      ),
      decoration:
          BoxDecoration(border: Border.all(color: borderColor, width: 3)),
      // color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.library_add_check_outlined,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      if (widget.productCount != "1") {
                        List<DialogButton> decisionButtons = [
                          DialogButton(
                            text: 'نعم',
                            onTap: () {
                              Navigator.of(context).pop();

                              widget.onCheckbox(widget.index);
                            },
                          ),
                          DialogButton(
                            text: 'لا',
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ];
                        showMyDialog(
                            "تحقق من الكمية",
                            "هل أنت متأكد انك وجدت ${widget.productCount} قطعة من ${widget.productName}",
                            decisionButtons,
                            null,
                            context);
                        // _showDialog();
                      } else {
                        widget.onCheckbox(widget.index);
                      }
                    }),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return FullScreenImage(
                        imageUrl: widget.img,
                        tag: "generate_a_unique_tag",
                      );
                    }));
                  },
                  child: new Container(
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
                            ))),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
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
                                style: darkBold,
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Wrap(
                            children: [
                              Text(
                                widget.quantity + " " + widget.unit,
                                style: darkBold,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          SizedBox(height: 8),
                          Text(
                            UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(widget.price)
                                    .toString() +
                                " ${LoadingScreenServices.companyInformation.currency}",
                            style: darkBold.copyWith(
                              color: UtilsImporter().colorUtils.primarycolor,
                            ),
                          ),
                          subWarehouseList.length > 0
                              ? DropdownButton(
                                  items: subWarehouseList,
                                  onChanged: (a) {
                                    OrderDetailsServices.updateOrder(
                                        orderId: widget.orderId.toString(),
                                        context: context,
                                        updateKey: "sub_warehouse_id",
                                        updateValue: a.toString(),
                                        productId: widget.productId);
                                    setState(() {
                                      widget.subWarehouseId = a;
                                    });
                                  },
                                  hint: subWarehouseList.firstWhere(
                                      (element) =>
                                          element.value ==
                                          widget.subWarehouseId, orElse: () {
                                    subWarehouseList.clear();
                                    return DropdownMenuItem(
                                        child: Text("No element"));
                                  }).child,
                                )
                              : Container(),
                          Switch(
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

                              result =
                                  await ProductsServices.updateProductsDetails(
                                bodyKey: "is_active",
                                value: value ? "1" : "0",
                                productId: widget.productId,
                                isForSubWarehouse: true,
                                subWarehouseId: widget
                                    .productsData.subWarehouseId
                                    .toString(),
                              );

                              if (result) {
                                Flushbar(
                                  backgroundColor: Colors.green,
                                  // titleText: Text("تمت الإضافة بنجاح"),
                                  messageText: Text(
                                    "تم التعديل بنجاح",
                                    style: flushBarStyle,
                                  ),

                                  boxShadows: [
                                    BoxShadow(
                                      color: UtilsImporter()
                                          .colorUtils
                                          .primarycolor,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 3.0,
                                    )
                                  ],
                                  icon: Icon(
                                    Icons.assignment_turned_in,
                                    size: 28.0,
                                    color: Colors.white,
                                  ),
                                  duration: Duration(seconds: 3),
                                  leftBarIndicatorColor:
                                      UtilsImporter().colorUtils.kmColors,
                                )..show(context);
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
                                  duration: Duration(seconds: 3),
                                  // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                                )..show(context);
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
                            activeColor: UtilsImporter().colorUtils.kmColors,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      child: Text(
                    widget.productCount,
                    style: mainStyle.copyWith(fontSize: 25),
                  )),
                )
              ],
            ),
            SizedBox(height: 4),
            Divider()
          ],
        ),
      ),
    );
  }
}

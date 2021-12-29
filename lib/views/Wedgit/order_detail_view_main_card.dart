import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/views/Wedgit/product_check_widget.dart';
import 'package:kammun_app/views/Wedgit/switch_product_status_widget.dart';
import '../../utils/Styles.dart';
import 'package:kammun_app/utils/colors_utils.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/full_screen_image.dart';
import 'package:kammun_app/views/order_details/services/order_details_services.dart';

// ignore: must_be_immutable
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
    for (int i = 0; i < LoadingScreenServices.subWarehouses.length; i++) {
      subWarehouseList.add(DropdownMenuItem(
        child: AutoSizeText(
          LoadingScreenServices.subWarehouses[i].name,
          overflow: TextOverflow.fade,
          maxLines: 1,
          maxFontSize: 15,
          style: mainStyle,
        ),
        value: LoadingScreenServices.subWarehouses[i].id,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subWarehouseId == 2 || widget.subWarehouseId == 6) {
      borderColor = ColorUtils().khawajaColor;
    } else if (widget.subWarehouseId == 3) {
      borderColor = ColorUtils().vegetableColor;
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
                ProductCheckWidget(
                  preferLeftSide: !LoadingScreenServices.preferLeftSide,
                  productCount: widget.productCount,
                  productName: widget.productName,
                  index: widget.index,
                  onCheckbox: (index) => widget.onCheckbox(index),
                ), //right side
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return FullScreenImage(
                            imageUrl: widget.img,
                            tag: "generate_a_unique_tag",
                          );
                        },
                      ),
                    );
                  },
                  child: new Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(20.0))),
                    child: Hero(
                      tag: widget.index + 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
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
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3),
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
                                style: mainStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Wrap(
                            children: [
                              Text(
                                widget.quantity + " " + widget.unit,
                                style: mainStyle.copyWith(
                                  color:
                                      UtilsImporter().colorUtils.primaryColor,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            UtilsImporter()
                                    .stringUtils
                                    .oCcy
                                    .format(widget.price)
                                    .toString() +
                                " ${LoadingScreenServices.companyInformation.currency}",
                            style: mainStyle.copyWith(
                                color: UtilsImporter().colorUtils.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
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
                          SwitchProductStatusWidget(
                            height: 20,
                            width: 70,
                            preState: widget.active,
                            subWarehouseId: widget.productsData.subWarehouseId,
                            productId: widget.productId,
                            onChange: (active) {
                              widget.active = active;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ProductCheckWidget(
                  preferLeftSide: LoadingScreenServices.preferLeftSide,
                  productCount: widget.productCount,
                  productName: widget.productName,
                  index: widget.index,
                  onCheckbox: (index) => widget.onCheckbox(index),
                ),
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

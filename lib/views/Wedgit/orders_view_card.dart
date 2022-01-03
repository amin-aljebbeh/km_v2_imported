import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/Wedgit/order_information_row.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class OrdersViewCard extends StatefulWidget {
  int orderId;
  final String userNumber;
  final int deliveryMethodId;
  String deliveryName;
  String shopperName;
  int orderQuantity;
  String orderTotalPrice;
  int orderStatus;
  String orderCreatedDate;
  int underUpdate;
  String supportedCityId;
  final String address;
  final double lat;
  final double lon;
  final String entrance;
  final OrdersOriginalData orderData;

  OrdersViewCard({
    @required this.orderId,
    this.orderQuantity,
    this.orderTotalPrice,
    this.orderStatus,
    this.orderCreatedDate,
    this.supportedCityId,
    this.address,
    this.lat,
    this.lon,
    this.userNumber,
    this.deliveryMethodId,
    @required this.entrance,
    this.underUpdate,
    this.shopperName,
    this.deliveryName,
    @required this.orderData,
  });

  @override
  State<StatefulWidget> createState() {
    return OrdersViewCardState();
  }
}

_makePhoneCall(String number) async {
  String url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openMapsSheet(context, lat, lon) async {
  try {
    // final coords = Coords(lat, lon);
    // final title = "Ocean Beach";
    // final availableMaps = await MapLauncher.installedMaps;

    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SafeArea(
    //       child: SingleChildScrollView(
    //         child: Container(
    //           child: Wrap(
    //             children: <Widget>[
    //               for (var map in availableMaps)
    //                 ListTile(
    //                   onTap: () => map.showMarker(
    //                     coords: coords,
    //                     title: title,
    //                   ),
    //                   title: Text(map.mapName),
    //                   leading: Icon(Icons.map),
    //                 ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    // },
    // );
  } catch (e) {
    print(e);
  }
}

class OrdersViewCardState extends State<OrdersViewCard> {
  String shopperName, deliveryName;

  void initState() {
    shopperName = widget.shopperName != null ? widget.shopperName : null;
    deliveryName = widget.deliveryName != null ? widget.deliveryName : null;
    super.initState();
  }

  String orderStatus = "طلبك قيد المعالجة ⌛️";

  @override
  Widget build(BuildContext context) {
    if (widget.orderStatus == 2) orderStatus = "تم قبول الطلب ✅";
    if (widget.orderStatus == 3) orderStatus = "تم تجهيز الطلب 😎";
    if (widget.orderStatus == 4)
      orderStatus = "تم إرسال الطلب مع كابتن التوصيل";
    if (widget.underUpdate == 1)
      orderStatus = "الطلب معلق حتى يأكد الزبون التعديل";

    if (widget.underUpdate == 2)
      orderStatus = "الطلب معلق حتى تقوم بتأكيد التعديل";

    if (widget.orderStatus == 5) orderStatus = "تم توصيل الطلب بنجاح";
    if (widget.orderStatus == 6) orderStatus = "تم إلغاء الطلب من قبلكم 🚫";
    if (widget.orderStatus == 7) orderStatus = "😔 لم نستطع تأمين الطلب 😔";

    return Container(
      decoration: widget.deliveryMethodId == 2
          ? BoxDecoration(border: Border.all(color: Colors.red, width: 5))
          : widget.deliveryMethodId == 3
              ? BoxDecoration(border: Border.all(color: Colors.green, width: 5))
              : BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 5)),
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OrderInformationRow(
                  rightSideText: StringUtils.bill,
                  leftSideText:
                      "${StringUtils().oCcy.format(int.parse(widget.orderTotalPrice)).toString()}" +
                          " ${LoadingScreenServices.companyInformation.currency.toString()}",
                  leftSideStyle: informationStyle,
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorUtils.greyColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    widget.orderQuantity.toString(),
                    style: paragraphStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.orderId.toString().length >= 3
                          ? "#${widget.orderId.toString().substring(2, widget.orderId.toString().length)}"
                          : '#${widget.orderId.toString()}',
                      style: profitStyle.copyWith(
                        color: Colors.purple,
                      ),
                    ),
                    if (Services.isShopper())
                      RichText(
                        text: TextSpan(
                          text:
                              "${StringUtils().oCcy.format(widget.orderData.shopperProfit).toString()}",
                          style: profitStyle,
                        ),
                      ),
                  ],
                )
              ],
            ),
            OrderInformationRow(
              rightSideText: StringUtils.phoneNumber,
              leftSideText: widget.userNumber,
              leftSideStyle: paragraphStyle.copyWith(
                color: ColorUtils.kmColors,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _makePhoneCall(widget.userNumber),
            ),
            OrderInformationRow(
              rightSideText: StringUtils.address + " : ",
              leftSideText: widget.address,
              leftSideStyle: informationStyle,
            ),
            OrderInformationRow(
              rightSideText: StringUtils.city,
              leftSideText: LoadingScreenServices.supportedCitiesListIntro
                      .where((supportedCity) =>
                          supportedCity.id == widget.supportedCityId)
                      .first
                      .name +
                  "   ",
              leftSideStyle: informationStyle,
            ),
            OrderInformationRow(
              rightSideText: StringUtils.entrance,
              leftSideText: widget.entrance,
              leftSideStyle: informationStyle,
            ),
            OrderInformationRow(
              rightSideText: StringUtils.orderDate,
              leftSideText: widget.orderCreatedDate,
              leftSideStyle: disableStyle,
            ),
            OrderInformationRow(
              rightSideText: orderStatus,
              leftSideText: '',
              leftSideStyle: informationStyle,
            ),
            OrderInformationRow(
              rightSideText: StringUtils.shopperName + " ",
              leftSideText: shopperName != null ? shopperName : " ",
              leftSideStyle: paragraphStyle,
            ),
          ],
        ),
      ),
    );
  }
}

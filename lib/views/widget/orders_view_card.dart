import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/order_details/order_details_tab_view.dart';

class OrdersViewCard extends StatefulWidget {
  final OrdersOriginalData orderData;
  final OrderTypes orderType;

  OrdersViewCard({
    @required this.orderData,
    @required this.orderType,
  });

  @override
  State<StatefulWidget> createState() {
    return OrdersViewCardState();
  }
}

openMapsSheet(context, lat, lon) async {
  try {} catch (e) {}
}

class OrdersViewCardState extends State<OrdersViewCard> {
  int deletedCount;

  void initState() {
    deletedCount = widget.orderData.products.where((product) => product.pivot.deletedAt != 'null').length;
    super.initState();
  }

  String orderStatus = "طلبك قيد المعالجة ⌛️";

  @override
  Widget build(BuildContext context) {
    switch (widget.orderData.orderStatusId) {
      case '2':
        orderStatus = "تم قبول الطلب ✅";
        break;
      case '3':
        orderStatus = "تم تجهيز الطلب 😎";
        break;
      case '4':
        orderStatus = "تم إرسال الطلب مع كابتن التوصيل";
        break;
      case '5':
        orderStatus = "تم توصيل الطلب بنجاح";
        break;
      case '6':
        orderStatus = "تم إلغاء الطلب من قبلكم 🚫";
        break;
      case '7':
        orderStatus = "😔 لم نستطع تأمين الطلب 😔";
        break;
    }
    switch (widget.orderData.underUpdate) {
      case '1':
        orderStatus = "الطلب معلق حتى يأكد الزبون التعديل";
        break;
      case '2':
        orderStatus = "الطلب معلق حتى تقوم بتأكيد التعديل";
        break;
    }

    Color color = widget.orderData.userData.orderCount <= 3 && !widget.orderData.userData.orderCount.isNegative
        ? ColorUtils.kmColors2
        : widget.orderData.deliveryMethodId == '2'
            ? Colors.red
            : widget.orderData.deliveryMethodId == '3'
                ? Colors.green
                : Colors.transparent;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new OrderDetailsTabView(
              orderData: widget.orderData,
              subTotal: int.parse(widget.orderData.total.toString().split(".")[0]) -
                  int.parse(widget.orderData.supportedCityCost.toString().split(".")[0]) -
                  int.parse(widget.orderData.deliveryCost.split(".")[0]),
              total: widget.orderData.total.toString(),
              orderType: widget.orderType,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: color, width: 5)),
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LabelRow(
                    rightSideText: StringUtils.bill,
                    leftSideText: "${StringUtils().oCcy.format(int.parse(widget.orderData.total)).toString()}" +
                        " ${LoadingScreenServices.companyInformation.currency.toString()}",
                    leftSideStyle: informationStyle,
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.greyColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      widget.orderData.products
                          .where((product) => product.pivot.deletedAt == 'null')
                          .length
                          .toString(),
                      style: paragraphStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (Services.isAdmin() && deletedCount > 0)
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Text(
                        deletedCount.toString(),
                        style: loseStyle.copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (Services.isOperationManager() &&
                      (widget.orderData.userDeliveryRating != 'null' || widget.orderData.userFeedback != 'null'))
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: ColorUtils.kmColors2,
                        size: 30,
                      ),
                      onPressed: () {
                        showMyDialog(
                          title: StringUtils.ratingOrder,
                          context: context,
                          text: (widget.orderData.userDeliveryRating != 'null'
                                  ? widget.orderData.userDeliveryRating + '\n'
                                  : '') +
                              (widget.orderData.userFeedback != 'null'
                                  ? widget.orderData.userFeedback + '\n'
                                  : ''),
                          dialogButtons: [
                            DialogButton(
                              text: StringUtils.close,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.orderData.id.toString().length >= 3
                            ? "#${widget.orderData.id.toString().substring(widget.orderData.id.toString().length - 3, widget.orderData.id.toString().length)}"
                            : '#${widget.orderData.id.toString()}',
                        style: profitStyle.copyWith(
                          color: Colors.purple,
                        ),
                      ),
                      if (Services.isShopper())
                        RichText(
                          text: TextSpan(
                            text: "${StringUtils().oCcy.format(widget.orderData.shopperProfit).toString()}",
                            style: profitStyle,
                          ),
                        ),
                    ],
                  )
                ],
              ),
              LabelRow(
                rightSideText: StringUtils.phoneNumber,
                leftSideText: widget.orderData.userData.phone,
                leftSideStyle: paragraphStyle.copyWith(
                  color: ColorUtils.kmColors,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Services.makePhoneCall(widget.orderData.userData.phone),
              ),
              LabelRow(
                rightSideText: StringUtils.address + " : ",
                leftSideText: widget.orderData.address.street +
                    " " +
                    widget.orderData.address.building +
                    " طابق " +
                    widget.orderData.address.floor +
                    " " +
                    widget.orderData.address.description,
                leftSideStyle: informationStyle,
              ),
              LabelRow(
                rightSideText: StringUtils.city,
                leftSideText: LoadingScreenServices.supportedCitiesListIntro
                        .where((supportedCity) => supportedCity.id == widget.orderData.supportedCityId)
                        .first
                        .name +
                    "   ",
                leftSideStyle: informationStyle,
              ),
              LabelRow(
                rightSideText: StringUtils.entrance,
                leftSideText: widget.orderData.address.entrance,
                leftSideStyle: informationStyle,
              ),
              LabelRow(
                rightSideText: StringUtils.orderDate,
                leftSideText: DateFormat('a h:mm - dd-MM-yyyy').format(widget.orderData.createdAt),
                leftSideStyle: disableStyle,
              ),
              LabelRow(
                rightSideText: orderStatus,
                leftSideText: '',
                leftSideStyle: informationStyle,
              ),
              LabelRow(
                rightSideText: StringUtils.shopperName + " ",
                leftSideText: widget.orderData.shopper != null ? widget.orderData.shopper.name : " ",
                leftSideStyle: paragraphStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

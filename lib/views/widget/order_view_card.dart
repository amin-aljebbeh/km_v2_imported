import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import '../order_details/order_detail_view.dart';

class OrdersViewCard extends StatefulWidget {
  final OrdersOriginalData order;
  final int orderQuantity;
  final String orderTitle;
  final String orderTotalPrice;
  final int orderStatus;
  final String orderCreatedDate;
  final int underUpdate;

  const OrdersViewCard({
    Key key,
    this.orderQuantity,
    this.orderTitle,
    this.orderTotalPrice,
    this.orderStatus,
    this.orderCreatedDate,
    this.underUpdate,
    this.order,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrdersViewCardState();
  }
}

class OrdersViewCardState extends State<OrdersViewCard> {
  String orderStatus = "طلبك قيد المعالجة ⌛️";
  @override
  Widget build(BuildContext context) {
    if (widget.orderStatus == 2) orderStatus = "تم قبول طلبك ✅";
    if (widget.underUpdate == 1) {
      orderStatus = "طلبك معلق حتى تأكيد التعديل";
    }
    if (widget.underUpdate == 2) {
      orderStatus = "يقوم مسؤول الطلب بتعديل طلبكم";
    }
    if (widget.orderStatus == 3) orderStatus = "تم تجهيز الطلب 😎";
    if (widget.orderStatus == 4) orderStatus = "تم إرسال طلبك مع كابتن التوصيل";
    if (widget.orderStatus == 5) orderStatus = "تم توصيل طلبك بنجاح ";
    if (widget.orderStatus == 6) orderStatus = "تم إلغاء الطلب من قبلكم 🚫";
    if (widget.orderStatus == 7) orderStatus = "😔 لم نستطع تأمين الطلب 😔";

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailView(
            ordersAry: widget.order.products,
            subTotal: int.parse(widget.order.total.toString().split(".")[0]) -
                int.parse(widget.order.supportedCityCost.toString().split(".")[0]) -
                int.parse(widget.order.deliveryCost.split(".")[0]),
            total: widget.order.total.toString(),
            deliveryPrice: (int.parse(widget.order.supportedCityCost.split(".")[0]) +
                    int.parse(widget.order.deliveryCost.split(".")[0]))
                .toString(),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.greyColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      widget.orderQuantity.toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "الفاتورة : ",
                                    style: TextStyle(
                                      color: ColorUtils.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    ),
                                  ),
                                  TextSpan(
                                    text: StringUtils().oCcy.format(int.parse(widget.orderTotalPrice)).toString() +
                                        " ${LoadingScreenServices.companyInformation.currency.toString()}",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "تاريخ الطلب : ",
                                  style: TextStyle(
                                    color: ColorUtils.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.orderCreatedDate,
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            orderStatus,
                            style: TextStyle(
                                color: ColorUtils.greyColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

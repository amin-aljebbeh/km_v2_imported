import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';

import 'widgets_importer.dart';

class SupplierOrdersViewCard extends StatefulWidget {
  final OrdersOriginalData order;

  const SupplierOrdersViewCard({Key key, @required this.order})
      : super(key: key);

  @override
  _SupplierOrdersViewCardState createState() => _SupplierOrdersViewCardState();
}

class _SupplierOrdersViewCardState extends State<SupplierOrdersViewCard> {
  int getSupplierDues(int supplierId) {
    return int.parse(widget.order.orderAccountingRows
        .firstWhere((row) => row.subWarehouseId == supplierId)
        .payToSubWarehouse
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new OrderDetailView(
              orderData: widget.order,
              orderId: widget.order.id,
              ordersAry: widget.order.products,
              addressName: widget.order.address.street,
              subTotal: int.parse(widget.order.total.toString().split(".")[0]) -
                  int.parse(
                      widget.order.supportedCityCost.toString().split(".")[0]) -
                  int.parse(widget.order.deliveryCost.split(".")[0]),
              total: widget.order.total.toString(),
              deliveryPrice:
                  (int.parse(widget.order.supportedCityCost.split(".")[0]) +
                          int.parse(widget.order.deliveryCost.split(".")[0]))
                      .toString(),
              orderType: OrderType.myOrder,
            ),
          ),
        ),
      },
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
                      "${StringUtils().oCcy.format(int.parse(widget.order.total)).toString()}" +
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
                    widget.order.products.length.toString(),
                    style: paragraphStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.order.id.toString().length >= 3
                          ? "#${widget.order.id.toString().substring(2, widget.order.id.toString().length)}"
                          : '#${widget.order.id.toString()}',
                      style: profitStyle.copyWith(
                        color: Colors.purple,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: //TODO:replace this with real supplier id
                            "${StringUtils().oCcy.format(getSupplierDues(1)).toString()}",
                        style: profitStyle,
                      ),
                    ),
                  ],
                )
              ],
            ),
            OrderInformationRow(
              rightSideText: StringUtils.orderDate,
              leftSideText: DateFormat('a h:mm - dd-MM-yyyy')
                  .format(widget.order.createdAt),
              leftSideStyle: disableStyle,
            ),
            OrderInformationRow(
              rightSideText: StringUtils.shopperName + " ",
              leftSideText: widget.order.shopper != null
                  ? widget.order.shopper.name
                  : " ",
              leftSideStyle: paragraphStyle,
            ),
          ],
        ),
      ),
    );
  }
}

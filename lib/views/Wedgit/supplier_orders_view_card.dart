import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:intl/intl.dart';
import 'package:kammun_app/views/order_details/order_details_view_main.dart';

import '../../Services.dart';
import 'widgets_importer.dart';

class SupplierOrdersViewCard extends StatefulWidget {
  final OrdersOriginalData order;

  const SupplierOrdersViewCard({Key key, @required this.order})
      : super(key: key);

  @override
  _SupplierOrdersViewCardState createState() => _SupplierOrdersViewCardState();
}

class _SupplierOrdersViewCardState extends State<SupplierOrdersViewCard> {
  int productsCount() {
    return widget.order.products
        .where((product) => product.pivot.deletedAt == null)
        .length;
  }

  productsNetPrice() {
    double total = 0;
    for (int i = 0; i < widget.order.products.length; i++) {
      if ((widget.order.products[i].pivot.deletedAt == null)) {
        double subTotal =
            ((double.parse(widget.order.products[i].pivot.purchasePrice) -
                widget.order.products[i].pivot.increaseValue));
        widget.order.products[i].pivot.purchasePrice = subTotal.toString();
        subTotal *= double.parse(widget.order.products[i].pivot.quantity);
        total += subTotal;
      }
    }
    widget.order.total = total.toString();
  }

  @override
  void initState() {
    productsCount();
    productsNetPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double discountPercentage = SubWarehouse.getDiscountPercentage(
        widget.order.products[0].subWarehouseId);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new OrderDetailViewMain(
              ordersAry: widget.order.products,
              addressName: 'widget.order.address.street',
              orderId: widget.order.id,
              subTotal: int.parse((double.parse(widget.order.total) -
                      double.parse(widget.order.total) * discountPercentage)
                  .toString()
                  .split('.')[0]),
              total: widget.order.total,
              deliveryPrice: '0',
              order: widget.order,
              orderType: OrderType.myOrder,
            ),
          ),
        ),
      },
      child: Column(
        children: [
          Padding(
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
                      leftSideText:
                          "${StringUtils().oCcy.format(int.parse(widget.order.total.split('.')[0])).toString()}" +
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
                        productsCount().toString(),
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
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                LabelRow(
                  rightSideText: StringUtils.orderDate,
                  leftSideText: DateFormat('a h:mm - dd-MM-yyyy')
                      .format(widget.order.createdAt),
                  leftSideStyle: disableStyle,
                ),
                LabelRow(
                  rightSideText: StringUtils.shopperName + " ",
                  leftSideText: widget.order.shopper != null
                      ? widget.order.shopper.name
                      : " ",
                  leftSideStyle: paragraphStyle,
                ),
                LabelRow(
                  rightSideText: StringUtils.phoneNumber,
                  leftSideText: widget.order.shopper != null
                      ? widget.order.shopper.admin.phone
                      : " ",
                  leftSideStyle: paragraphStyle.copyWith(
                    color: ColorUtils.kmColors,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Services.makePhoneCall(
                        widget.order.shopper != null
                            ? widget.order.shopper.admin.phone
                            : "0969999204"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Divider(
              thickness: 5,
              color: ColorUtils.kmColors2,
            ),
          ),
        ],
      ),
    );
  }
}

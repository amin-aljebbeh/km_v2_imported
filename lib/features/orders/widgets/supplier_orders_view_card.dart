import 'package:intl/intl.dart';

import '../../../core/core_importer.dart';

class SupplierOrdersViewCard extends StatefulWidget {
  final OrdersOriginalData order;

  const SupplierOrdersViewCard({Key key, @required this.order}) : super(key: key);

  @override
  _SupplierOrdersViewCardState createState() => _SupplierOrdersViewCardState();
}

class _SupplierOrdersViewCardState extends State<SupplierOrdersViewCard> {
  double productsNetPrice() {
    double total = 0;
    for (int i = 0; i < widget.order.products.length; i++) {
      if ((widget.order.products[i].pivot.deletedAt == 'null')) {
        double subTotal = ((double.parse(widget.order.products[i].pivot.purchasePrice) -
            widget.order.products[i].pivot.increaseValue));
        subTotal *= double.parse(widget.order.products[i].pivot.quantity);
        total += subTotal;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => OrderTabsPage(order: widget.order, orderType: OrderTypes.myOrder)));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    LabelRow(
                      rightSideText: bill,
                      leftSideText: '${StringUtils().oCcy.format(productsNetPrice())}'
                          ' ${StaticVariables.companyInformation.currency}',
                      leftSideStyle: informationStyle,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(0.2))),
                      child: Text(
                          widget.order.products.where((product) => product.pivot.deletedAt == 'null').length.toString(),
                          style: paragraphStyle,
                          textAlign: TextAlign.center),
                    ),
                    Text(
                      widget.order.id.toString().length >= 3
                          ? '#${widget.order.id.toString().substring(2, widget.order.id.toString().length)}'
                          : '#${widget.order.id.toString()}',
                      style: profitStyle.copyWith(color: Colors.purple),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: LabelRow(
                    rightSideText: orderDate,
                    leftSideText: DateFormat('a h:mm - dd-MM-yyyy').format(widget.order.createdAt),
                    leftSideStyle: disableStyle,
                  ),
                ),
                LabelRow(
                  rightSideText: shopperName + ' ',
                  leftSideText: widget.order.shopper != null ? widget.order.shopper.name : ' ',
                  leftSideStyle: paragraphStyle,
                ),
                LabelRow(
                  rightSideText: phoneNumberString,
                  leftSideText: widget.order.shopper != null ? widget.order.shopper.admin.phone : ' ',
                  leftSideStyle: paragraphStyle.copyWith(color: kmColors),
                  onTap: () => Services.makePhoneCall(
                      widget.order.shopper != null ? widget.order.shopper.admin.phone : '0969999204'),
                ),
              ],
            ),
          ),
          if (widget.order.userNotes.toString() != 'null')
            KammunButton(
              text: watchNote,
              onTap: () {
                showMyDialog(
                    context: context,
                    title: costumerNote,
                    text: widget.order.userNotes,
                    dialogButtons: [const CloseWidget()]);
              },
              color: Colors.indigoAccent,
            ),
          Padding(padding: const EdgeInsets.only(top: 8.0), child: Divider(thickness: 5, color: kmColors2)),
        ],
      ),
    );
  }
}

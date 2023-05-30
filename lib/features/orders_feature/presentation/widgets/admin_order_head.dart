import '../../../../core/core_importer.dart';
import '../../domain/entities/order_entity.dart';
import '../../services.dart';
import '../redux/orders_action.dart';

class AdminOrderHead extends StatelessWidget {
  final OrderEntity order;

  const AdminOrderHead({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LabelRow(
          rightSideText: bill,
          leftSideText: StringUtils().oCcy.format(int.parse(order.cashValue.split('.')[0]).abs()) +
              ' ' +
              StaticVariables.companyInformation.currency,
          leftSideStyle: int.parse(order.cashValue.split('.')[0]).isNegative
              ? informationStyle.copyWith(color: Colors.red)
              : informationStyle,
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(0.2))),
          child: Text(
            order.products.where((product) => product.pivot.deletedAt == 'null').length.toString(),
            style: paragraphStyle,
            textAlign: TextAlign.center,
          ),
        ),
        if (Services.hasRole(context, operationManagerRole) &&
            order.products.where((product) => product.pivot.deletedAt != 'null').isNotEmpty)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(border: Border.all(color: Colors.red.withOpacity(0.2))),
            child: Text(order.products.where((product) => product.pivot.deletedAt != 'null').length.toString(),
                style: loseStyle.copyWith(fontSize: 18), textAlign: TextAlign.center),
          ),
        if (Services.hasRole(context, agentRole) && (order.userPriceRating != 'null'))
          IconButton(
            icon: Icon(Icons.star_rounded,
                color: order.userDeliveryRating == 'null'
                    ? Colors.black
                    : int.parse(order.userDeliveryRating.split('.')[0]) < 5
                        ? Colors.red
                        : kmColors2,
                size: 30),
            padding: EdgeInsets.zero,
            onPressed: () {
              int rate;
              rate = order.userDeliveryRating != 'null' ? int.parse(order.userDeliveryRating) : null;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text(ratingOrder, style: dialogStyle),
                        scrollable: true,
                        content: Column(
                          children: [
                            Text(order.userDeliveryRating.toString() + '\n' + order.userFeedback + '\n',
                                style: dialogStyle),
                            DropdownButton(
                                items: [1, 2, 3, 4, 5, null]
                                    .map((rate) => DropdownMenuItem<int>(
                                        child: Text(rate.toString(), style: dropdownItemStyle), value: rate))
                                    .toList(),
                                value: rate,
                                onChanged: (value) {
                                  setState(() => rate = value);
                                  StoreProvider.of<AppState>(context).dispatch(UpdateOrderRatingAction(
                                      deliveryRating: value, orderId: order.id, context: context));
                                })
                          ],
                        ),
                        actions: const [CloseWidget()],
                      );
                    },
                  );
                },
              );
            },
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              order.id.toString().length >= 3
                  ? '#${order.id.toString().substring(order.id.toString().length - 3, order.id.toString().length)}'
                  : '#${order.id.toString()}',
              style: profitStyle.copyWith(color: Colors.purple),
            ),
            Text(
                StringUtils().oCcy.format(order.shopperProfit +
                    (order.shopper != null
                        ? gasAllowance(
                            deliveryDistance: order.deliveryDistance, context: context, levelId: order.shopper.levelId)
                        : 0)),
                style: profitStyle)
          ],
        )
      ],
    );
  }
}

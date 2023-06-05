import '../../../../core/core_importer.dart';
import '../../domain/entities/order_entity.dart';

class SupplierOrderHead extends StatelessWidget {
  final OrderEntity order;

  const SupplierOrderHead({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Text(order.products.where((product) => product.pivot.deletedAt == 'null').length.toString(),
              style: paragraphStyle, textAlign: TextAlign.center),
        ),
        Text(
          order.id.toString().length >= 3
              ? '#${order.id.toString().substring(2, order.id.toString().length)}'
              : '#${order.id.toString()}',
          style: profitStyle.copyWith(color: Colors.purple),
        )
      ],
    );
  }

  double productsNetPrice() {
    double total = 0;
    for (int i = 0; i < order.products.length; i++) {
      if ((order.products[i].pivot.deletedAt == 'null')) {
        double subTotal =
            ((double.parse(order.products[i].pivot.purchasePrice) - order.products[i].pivot.increaseValue));
        subTotal *= double.parse(order.products[i].pivot.quantity);
        total += subTotal;
      }
    }
    return total;
  }
}

import 'package:kammun_app/features/order_details_feature/order_details_services.dart';

import '../../../../core/core_importer.dart';

class SupplierOrderDetailsWidget extends StatelessWidget {
  final OrdersOriginalData order;

  const SupplierOrderDetailsWidget({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('الزوائد', style: darkBold),
              Text(
                '${StringUtils().oCcy.format(remaining)}'
                ' ${StaticVariables.companyInformation.currency}',
                style: mainStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('إجمالي الحسم', style: darkBold),
              Text(
                '${StringUtils().oCcy.format(totalDiscount)}'
                ' ${StaticVariables.companyInformation.currency}',
                style: mainStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5, right: 5, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(subtotalString, style: darkBold),
              Text(
                StringUtils().oCcy.format(kRound(subTotal())) + ' ' + StaticVariables.companyInformation.currency,
                style: mainStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double subTotal() {
    double total = 0;
    for (int i = 0; i < order.products.length; i++) {
      if ((order.products[i].pivot.deletedAt == 'null')) {
        double discountPercentage = SubWarehouse.getDiscountPercentage(order.products[i].subWarehouseId);
        double subTotal =
            (double.parse(order.products[i].pivot.purchasePrice) - order.products[i].pivot.increaseValue) -
                (double.parse(order.products[i].pivot.purchasePrice) * discountPercentage);
        subTotal *= double.parse(order.products[i].pivot.quantity);
        total += subTotal;
      }
    }
    return total;
  }

  double remaining() => subTotal() - kRound(subTotal());

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

  double totalDiscount() => productsNetPrice() - kRound(subTotal());
}

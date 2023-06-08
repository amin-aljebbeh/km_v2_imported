import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';

import '../../../../core/core_importer.dart';

class SupplierOrderDetailsWidget extends StatelessWidget {
  final OrderEntity order;

  const SupplierOrderDetailsWidget({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('الزوائد', style: darkBold),
                  Text(
                    '${StringUtils().oCcy.format(remaining(context))}'
                    ' ${state.generalInformationState.companyInformation.currency}',
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
                    '${StringUtils().oCcy.format(totalDiscount(context))}'
                    ' ${state.generalInformationState.companyInformation.currency}',
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
                    StringUtils().oCcy.format(Services.kRound(subTotal(context))) +
                        ' ' +
                        state.generalInformationState.companyInformation.currency,
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
      },
    );
  }

  double subTotal(BuildContext context) {
    double total = 0;
    for (int i = 0; i < order.products.length; i++) {
      if ((order.products[i].pivot.deletedAt == 'null')) {
        double discountPercentage = SubWarehouse.getDiscountPercentage(order.products[i].subWarehouseId, context);
        double subTotal =
            (double.parse(order.products[i].pivot.purchasePrice) - order.products[i].pivot.increaseValue) -
                (double.parse(order.products[i].pivot.purchasePrice) * discountPercentage);
        subTotal *= double.parse(order.products[i].pivot.quantity);
        total += subTotal;
      }
    }
    return total;
  }

  double remaining(BuildContext context) => subTotal(context) - Services.kRound(subTotal(context));

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

  double totalDiscount(BuildContext context) => productsNetPrice() - Services.kRound(subTotal(context));
}

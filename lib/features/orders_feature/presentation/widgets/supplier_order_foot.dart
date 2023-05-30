import '../../../../core/core_importer.dart';
import '../../domain/entities/order_entity.dart';

class SupplierOrderFoot extends StatelessWidget {
  final OrderEntity order;

  const SupplierOrderFoot({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelRow(
          rightSideText: shopperName + ' ',
          leftSideText: order.shopper != null ? order.shopper.name : ' ',
          leftSideStyle: paragraphStyle,
        ),
        LabelRow(
          rightSideText: phoneNumberString,
          leftSideText: order.shopper != null ? order.shopper.admin.phone : ' ',
          leftSideStyle: paragraphStyle.copyWith(color: kmColors),
          onTap: () => Services.makePhoneCall(order.shopper != null ? order.shopper.admin.phone : '0969999204'),
        ),
      ],
    );
  }
}

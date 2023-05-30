import '../../../../core/core_importer.dart';
import '../../domain/entities/order_entity.dart';
import '../../services.dart';
import 'assignment_management_widget.dart';
import 'operations_buttons_widget.dart';

class AdminOrderFoot extends StatelessWidget {
  final OrderEntity order;

  const AdminOrderFoot({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelRow(rightSideText: chooseOrderStatus(order), leftSideText: '', leftSideStyle: informationStyle),
        if (Services.hasRole(context, operationManagerRole) && order.orderStatusId == '5')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelRow(
                rightSideText: 'بين قبول الطلب وتوصيله : ',
                leftSideText: '  ' +
                    order.deliveredAt.difference(order.acceptedAt).inHours.toString() +
                    ':' +
                    (order.deliveredAt.difference(order.acceptedAt).inMinutes -
                            (order.deliveredAt.difference(order.acceptedAt).inHours * 60))
                        .toString(),
                leftSideStyle: (order.deliveryMethodId == '2' &&
                        order.deliveredAt.difference(order.acceptedAt).inMinutes > 45)
                    ? warningStyle
                    : (order.deliveryMethodId == '1' && order.deliveredAt.difference(order.acceptedAt).inMinutes > 90)
                        ? warningStyle
                        : disableStyle,
              ),
              LabelRow(
                rightSideText: 'بين إنشاء الطلب وتوصيله : ',
                leftSideText: '  ' +
                    order.deliveredAt.difference(order.createdAt).inHours.toString() +
                    ':' +
                    (order.deliveredAt.difference(order.createdAt).inMinutes -
                            (order.deliveredAt.difference(order.createdAt).inHours * 60))
                        .toString(),
                leftSideStyle: (order.deliveryMethodId == '2' &&
                        order.deliveredAt.difference(order.createdAt).inMinutes > 45)
                    ? warningStyle
                    : (order.deliveryMethodId == '1' && order.deliveredAt.difference(order.createdAt).inMinutes > 90)
                        ? warningStyle
                        : disableStyle,
              ),
            ],
          ),
        LabelRow(
            rightSideText: 'مسافة التوصيل : ',
            leftSideText: (int.parse(order.deliveryDistance) / 1000).toString() + ' كم ',
            leftSideStyle: informationStyle),
        if (Services.hasRole(context, operationManagerRole))
          Column(children: [AssignmentManagementWidget(order: order), OperationButtonsWidget(order: order)]),
      ],
    );
  }
}

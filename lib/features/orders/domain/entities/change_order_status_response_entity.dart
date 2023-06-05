import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';

class ChangeOrderStatusResponseEntity {
  final bool success;
  final String data;
  final OrderEntity order;

  ChangeOrderStatusResponseEntity({this.success, this.data, this.order});
}

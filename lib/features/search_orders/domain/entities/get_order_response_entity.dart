import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';
import 'package:kammun_app/features/orders/domain/entities/show_data_entity.dart';

class GetOrderResponseEntity {
  final bool success;
  final OrderEntity order;
  final ShowDataEntity showData;

  GetOrderResponseEntity({this.success, this.order, this.showData});
}

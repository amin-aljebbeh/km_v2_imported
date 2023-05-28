import 'package:kammun_app/features/orders_feature/data/models/order_model.dart';

import '../../domain/entities/change_order_status_response_entity.dart';

class ChangeOrderStatusResponseModel extends ChangeOrderStatusResponseEntity {
  ChangeOrderStatusResponseModel({bool success, String data, order})
      : super(success: success, data: data, order: order);

  factory ChangeOrderStatusResponseModel.fromJson(Map<String, dynamic> json) => ChangeOrderStatusResponseModel(
      success: json['success'], data: json['data'], order: OrderModel.fromJson(json['order']));
}

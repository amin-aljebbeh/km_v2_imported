import 'package:kammun_app/features/orders_feature/data/models/order_model.dart';
import 'package:kammun_app/features/orders_feature/data/models/show_data_model.dart';
import 'package:kammun_app/features/orders_feature/domain/entities/get_order_response_entity.dart';

class GetOrderResponseModel extends GetOrderResponseEntity {
  GetOrderResponseModel({success, order, showData}) : super(success: success, order: order, showData: showData);

  factory GetOrderResponseModel.fromJson(Map<String, dynamic> json) => GetOrderResponseModel(
      success: json['success'],
      order: OrderModel.fromJson(json['order']),
      showData: ShowDataModel.fromJson(json['data']));
}

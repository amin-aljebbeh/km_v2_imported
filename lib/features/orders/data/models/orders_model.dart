import 'package:kammun_app/features/orders/data/models/order_model.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/orders_page_data_entity.dart';

Orders ordersModelFromJson(String str) => Orders.fromJson(json.decode(str));

class Orders {
  Orders({this.success, this.data});

  bool success;
  OrdersPageDataModel data;

  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(success: json['success'], data: OrdersPageDataModel.fromJson(json['data']));
}

class OrdersPageDataModel extends OrdersPageDataEntity {
  OrdersPageDataModel({data, total}) : super(total: total, data: data);

  factory OrdersPageDataModel.fromJson(Map<String, dynamic> json) => OrdersPageDataModel(
      total: json['total'], data: List<OrderModel>.from(json['data'].map((x) => OrderModel.fromJson(x))));
}

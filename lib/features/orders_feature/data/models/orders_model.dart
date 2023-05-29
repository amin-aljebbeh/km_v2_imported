import 'package:kammun_app/features/orders_feature/data/models/order_model.dart';

import '../../../../core/core_importer.dart';

Orders ordersModelFromJson(String str) => Orders.fromJson(json.decode(str));

class Orders {
  Orders({this.success, this.data});

  bool success;
  PageData data;

  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(success: json['success'], data: PageData.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class PageData {
  PageData({this.data});

  List<OrderModel> data;

  factory PageData.fromJson(Map<String, dynamic> json) =>
      PageData(data: List<OrderModel>.from(json['data'].map((x) => OrderModel.fromJson(x))));

  Map<String, dynamic> toJson() => {'data': List<dynamic>.from(data.map((x) => x.toJson()))};
}

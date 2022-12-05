// To parse this JSON data, do
//
//     final louckOrder = louckOrderFromJson(jsonString);

import 'models_importer.dart';

LockOrder lockOrderFromJson(String str) => LockOrder.fromJson(json.decode(str));

String lockOrderToJson(LockOrder data) => json.encode(data.toJson());

class LockOrder {
  LockOrder({
    this.success,
    this.data,
    this.products,
  });

  bool success;
  String data;
  List<OrderProduct> products;

  factory LockOrder.fromJson(Map<String, dynamic> json) => LockOrder(
        success: json["success"],
        data: json["data"],
        products: List<OrderProduct>.from(json["products"].map((x) => OrderProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final louckOrder = louckOrderFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/models/start_model.dart';

LouckOrder louckOrderFromJson(String str) =>
    LouckOrder.fromJson(json.decode(str));

String louckOrderToJson(LouckOrder data) => json.encode(data.toJson());

class LouckOrder {
  LouckOrder({
    this.success,
    this.data,
    this.products,
  });

  bool success;
  String data;
  List<OrderProducts> products;

  factory LouckOrder.fromJson(Map<String, dynamic> json) => LouckOrder(
        success: json["success"],
        data: json["data"],
        products: List<OrderProducts>.from(
            json["products"].map((x) => OrderProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

OrderResponse orderResponseFromJson(String str) => OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  OrderResponse({
    this.success,
    this.reason,
    this.inactiveProducts,
    this.changedPriceProducts,
    this.data,
    this.message,
  });

  bool success;
  String reason;
  String message;
  List<String> inactiveProducts;
  List<String> changedPriceProducts;
  String data;

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    List<String> inactiveProducts = [];
    List<String> changedPriceProducts = [];

    return OrderResponse(
      success: json['success'],
      data: json['data'],
      reason: json['reason'].toString(),
      inactiveProducts: json['inactive_products'] != null
          ? List<String>.from(json['inactive_products'].map((x) => x))
          : inactiveProducts,
      changedPriceProducts: json['changed_price_products'] != null
          ? List<String>.from(json['changed_price_products'].map((x) => x))
          : changedPriceProducts,
      message: json['message'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'reason': reason,
        'data': data,
        'inactive_products': List<dynamic>.from(inactiveProducts.map((x) => x)),
        'changed_price_products': List<dynamic>.from(changedPriceProducts.map((x) => x)),
      };
}

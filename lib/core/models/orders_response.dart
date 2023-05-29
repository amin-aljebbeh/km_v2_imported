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
  List<ChangedPriceProduct> changedPriceProducts;
  String data;

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        success: json['success'],
        data: json['data'],
        reason: json['reason'].toString(),
        inactiveProducts: json['inactive_products'] != null
            ? List<String>.from(json['inactive_products'].map((x) => x.toString()))
            : [],
        changedPriceProducts: json['changed_price_products'] != null
            ? List<ChangedPriceProduct>.from(json['changed_price_products'].map((x) => ChangedPriceProduct.fromJson(x)))
            : [],
        message: json['message'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'reason': reason,
        'data': data,
        'inactive_products': List<dynamic>.from(inactiveProducts.map((x) => x)),
        'changed_price_products': List<dynamic>.from(changedPriceProducts.map((x) => x)),
      };
}

class ChangedPriceProduct {
  ChangedPriceProduct({this.id, this.oldPrice, this.newPrice});

  int id;
  int oldPrice;
  int newPrice;

  factory ChangedPriceProduct.fromJson(Map<String, dynamic> json) =>
      ChangedPriceProduct(id: json['id'], oldPrice: json['old_price'], newPrice: json['new_price']);

  Map<String, dynamic> toJson() => {'id': id, 'old_price': oldPrice, 'new_price': newPrice};
}

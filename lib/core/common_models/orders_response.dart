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
    this.message,
    this.ePaymentInfo,
  });

  bool success;
  String reason;
  List<String> inactiveProducts;
  List<ChangedPriceProduct> changedPriceProducts;
  String message;
  EPaymentInfo ePaymentInfo;

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'],
      message: json['message'],
      reason: json['reason'].toString(),
      inactiveProducts: json['inactive_products'] != null
          ? List<String>.from(json['inactive_products'].map((x) => x.toString()))
          : [],
      changedPriceProducts: json['changed_price_products'] != null
          ? List<ChangedPriceProduct>.from(
              json['changed_price_products'].map((x) => ChangedPriceProduct.fromJson(x)))
          : [],
      ePaymentInfo: json['data'] != null ? EPaymentInfo.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'reason': reason,
        'data': message,
        'inactive_products': List<dynamic>.from(inactiveProducts.map((x) => x)),
        'changed_price_products': List<dynamic>.from(changedPriceProducts.map((x) => x.toJson())),
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

class EPaymentInfo {
  EPaymentInfo({this.orderId, this.paymentMethodInfo});

  int orderId;
  List<PaymentInfo> paymentMethodInfo;

  factory EPaymentInfo.fromJson(Map<String, dynamic> json) => EPaymentInfo(
        orderId: json['order_id'],
        paymentMethodInfo: json['payment_method_info'] != null
            ? List<PaymentInfo>.from(json['payment_method_info'].map((x) => PaymentInfo.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() =>
      {'order_id': orderId, 'payment_method_info': List<dynamic>.from(paymentMethodInfo.map((x) => x.toJson()))};
}

class PaymentInfo {
  PaymentInfo({this.key, this.value});

  String key;
  String value;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) =>
      PaymentInfo(key: json['key'].toString(), value: json['value'].toString());

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}

// To parse this JSON data, do
//
//     final paymentMethodResponse = paymentMethodResponseFromJson(jsonString);

import 'dart:convert';

PaymentMethodResponse paymentMethodResponseFromJson(String str) =>
    PaymentMethodResponse.fromJson(json.decode(str));

String paymentMethodResponseToJson(PaymentMethodResponse data) => json.encode(data.toJson());

class PaymentMethodResponse {
  PaymentMethodResponse({
    this.success,
    this.data,
  });

  bool success;
  List<PaymentMethodModel> data;

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) => PaymentMethodResponse(
        success: json['success'],
        data: List<PaymentMethodModel>.from(json['data'].map((x) => PaymentMethodModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PaymentMethodModel {
  PaymentMethodModel({
    this.id,
    this.name,
    this.description,
    this.isEPayment,
    this.extraFees,
  });

  int id;
  String name;
  String description;
  int isEPayment;
  double extraFees;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        isEPayment: json['is_e_payment'],
        extraFees: json['extra_fees'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_e_payment': isEPayment,
        'extra_fees': extraFees,
      };
}

// To parse this JSON data, do
//
//     final checkInvoiceResponseModel = checkInvoiceResponseModelFromJson(jsonString);

import 'dart:convert';

import '../../../core/common_models/orders_response.dart';
import 'invoice_model.dart';
import '../../../core/common_models/key_value_info_model.dart';

CheckInvoiceResponseModel checkInvoiceResponseModelFromJson(String str) =>
    CheckInvoiceResponseModel.fromJson(json.decode(str));

String checkInvoiceResponseModelToJson(CheckInvoiceResponseModel data) => json.encode(data.toJson());

class CheckInvoiceResponseModel {
  CheckInvoiceResponseModel({
    this.success,
    this.data,
    this.changedPriceProducts,
    this.inactiveProducts,
    this.reason,
    this.message,
    this.statusCode,
  });

  bool success;
  String reason;
  String message;
  InvoiceData data;
  int statusCode;
  List<String> inactiveProducts;
  List<ChangedPriceProduct> changedPriceProducts;

  factory CheckInvoiceResponseModel.fromJson(Map<String, dynamic> json) => CheckInvoiceResponseModel(
        success: json['success'],
        data: json['data'] == null ? null : InvoiceData.fromJson(json['data']),
        inactiveProducts: json['inactive_products'] != null
            ? List<String>.from(json['inactive_products'].map((x) => x.toString()))
            : [],
        changedPriceProducts: json['changed_price_products'] != null
            ? List<ChangedPriceProduct>.from(json['changed_price_products'].map((x) => ChangedPriceProduct.fromJson(x)))
            : [],
        reason: json['reason'] ?? '',
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class InvoiceData {
  InvoiceData({
    this.invoice,
    this.invoiceInfo,
    this.paymentInfo,
    this.userBalance,
  });

  InvoiceModel invoice;
  List<KeyValueModel> invoiceInfo;
  List<KeyValueModel> paymentInfo;
  String userBalance;

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        invoice: InvoiceModel.fromJson(json['invoice']),
        invoiceInfo: List<KeyValueModel>.from(json['invoice_info'].map((x) => KeyValueModel.fromJson(x))),
        paymentInfo: json['payment_info'] == null
            ? null
            : List<KeyValueModel>.from(json['payment_info'].map((x) => KeyValueModel.fromJson(x))),
        userBalance: json['user_balance'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'invoice': invoice.toJson(),
        'invoice_info': List<dynamic>.from(invoiceInfo.map((x) => x.toJson())),
        'payment_info': List<dynamic>.from(paymentInfo.map((x) => x.toJson())),
      };
}

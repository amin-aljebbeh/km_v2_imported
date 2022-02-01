// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

import 'report_model_importer.dart';

ShopperTransactionResponse shopperTransactionResponseFromJson(String str) =>
    ShopperTransactionResponse.fromJson(json.decode(str));

String shopperTransactionResponseToJson(ShopperTransactionResponse data) => json.encode(data.toJson());

class ShopperTransactionResponse {
  ShopperTransactionResponse({
    this.success,
    this.data,
  });

  bool success;
  List<TransactionModel> data;

  factory ShopperTransactionResponse.fromJson(Map<String, dynamic> json) => ShopperTransactionResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<TransactionModel>.from(json["data"].map((x) => TransactionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

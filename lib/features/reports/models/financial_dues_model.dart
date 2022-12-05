// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

FinancialDuesResponseModel financialDuesResponseModelFromJson(String str) =>
    FinancialDuesResponseModel.fromJson(json.decode(str));

String financialDuesResponseModelToJson(FinancialDuesResponseModel data) => json.encode(data.toJson());

class FinancialDuesResponseModel {
  FinancialDuesResponseModel({
    this.success,
    this.data,
  });

  bool success;
  FinancialDuesModel data;

  factory FinancialDuesResponseModel.fromJson(Map<String, dynamic> json) => FinancialDuesResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : FinancialDuesModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class FinancialDuesModel {
  FinancialDuesModel({
    this.companyDues,
    this.totalShopperProfits,
  });

  String companyDues;
  String totalShopperProfits;

  factory FinancialDuesModel.fromJson(Map<String, dynamic> json) => FinancialDuesModel(
        companyDues: json["company_dues"] ?? '0',
        totalShopperProfits: json["total_shopper_profits"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "company_dues": companyDues,
        "total_shopper_profits": totalShopperProfits,
      };
}

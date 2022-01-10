// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

FinancialDuesResponseModel financialDuesResponseModelFromJson(String str) =>
    FinancialDuesResponseModel.fromJson(json.decode(str));

String financialDuesResponseModelToJson(FinancialDuesResponseModel data) =>
    json.encode(data.toJson());

class FinancialDuesResponseModel {
  FinancialDuesResponseModel({
    this.success,
    this.data,
  });

  bool success;
  FinancialDuesModel data;

  factory FinancialDuesResponseModel.fromJson(Map<String, dynamic> json) =>
      FinancialDuesResponseModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : FinancialDuesModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class FinancialDuesModel {
  FinancialDuesModel({
    this.companyDues,
    this.totalShopperProfits,
  });

  String companyDues;
  String totalShopperProfits;

  factory FinancialDuesModel.fromJson(Map<String, dynamic> json) =>
      FinancialDuesModel(
        companyDues: json["company_dues"] == null ? '0' : json["company_dues"],
        totalShopperProfits: json["total_shopper_profits"] == null
            ? '0'
            : json["total_shopper_profits"],
      );

  Map<String, dynamic> toJson() => {
        "company_dues": companyDues == null ? null : companyDues,
        "total_shopper_profits":
            totalShopperProfits == null ? null : totalShopperProfits,
      };
}

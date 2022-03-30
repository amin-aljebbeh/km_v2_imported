// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

ProfitsModelResponse profitsModelResponseFromJson(String str) => ProfitsModelResponse.fromJson(json.decode(str));

String profitsModelResponseToJson(ProfitsModelResponse data) => json.encode(data.toJson());

class ProfitsModelResponse {
  ProfitsModelResponse({
    this.success,
    this.data,
    this.date,
  });

  bool success;
  ProfitsModel data;
  ProfitDate date;

  factory ProfitsModelResponse.fromJson(Map<String, dynamic> json) => ProfitsModelResponse(
        success: json["success"],
        data: json["data"] == null ? null : ProfitsModel.fromJson(json["data"]),
        date: json["date"] == null ? null : ProfitDate.fromJson(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class ProfitsModel {
  ProfitsModel({
    this.totalShoppingProfits,
    this.shopperShoppingProfits,
    this.companyShoppingProfits,
    this.shopperIncreaseValueProfits,
    this.companyIncreaseValueProfits,
    this.shopperDeliveryProfits,
    this.companyDeliveryProfits,
    this.companyDeliveryMethodProfits,
  });

  String totalShoppingProfits;
  String shopperShoppingProfits;
  String companyShoppingProfits;
  String shopperIncreaseValueProfits;
  String companyIncreaseValueProfits;
  String shopperDeliveryProfits;
  String companyDeliveryProfits;
  String companyDeliveryMethodProfits;

  factory ProfitsModel.fromJson(Map<String, dynamic> json) => ProfitsModel(
        totalShoppingProfits: json["total_shopping_profits"],
        shopperShoppingProfits: json["shopper_shopping_profits"],
        companyShoppingProfits: json["company_shopping_profits"],
        shopperIncreaseValueProfits: json["shopper_increase_value_profits"],
        companyIncreaseValueProfits: json["company_increase_value_profits"],
        shopperDeliveryProfits: json["shopper_delivery_profits"],
        companyDeliveryProfits: json["company_delivery_profits"],
        companyDeliveryMethodProfits: json["company_delivery_method_profits"],
      );

  Map<String, dynamic> toJson() => {
        "total_shopping_profits": totalShoppingProfits,
        "shopper_shopping_profits": shopperShoppingProfits,
        "company_shopping_profits": companyShoppingProfits,
        "shopper_increase_value_profits": shopperIncreaseValueProfits,
        "company_increase_value_profits": companyIncreaseValueProfits,
        "shopper_delivery_profits": shopperDeliveryProfits,
        "company_delivery_profits": companyDeliveryProfits,
        "company_delivery_method_profits": companyDeliveryMethodProfits,
      };
}

class ProfitDate {
  ProfitDate({
    this.fromDate,
    this.toDate,
  });

  DateTime fromDate;
  DateTime toDate;

  factory ProfitDate.fromJson(Map<String, dynamic> json) => ProfitDate(
        fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
        toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
      );

  Map<String, dynamic> toJson() => {
        "from_date": fromDate.toIso8601String(),
        "to_date": toDate.toIso8601String(),
      };
}

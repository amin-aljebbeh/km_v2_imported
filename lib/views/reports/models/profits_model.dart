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
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : ProfitsModel.fromJson(json["data"]),
        date: json["date"] == null ? null : ProfitDate.fromJson(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
        "date": date == null ? null : date.toJson(),
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
        totalShoppingProfits: json["total_shopping_profits"] == null ? null : json["total_shopping_profits"],
        shopperShoppingProfits: json["shopper_shopping_profits"] == null ? null : json["shopper_shopping_profits"],
        companyShoppingProfits: json["company_shopping_profits"] == null ? null : json["company_shopping_profits"],
        shopperIncreaseValueProfits:
            json["shopper_increase_value_profits"] == null ? null : json["shopper_increase_value_profits"],
        companyIncreaseValueProfits:
            json["company_increase_value_profits"] == null ? null : json["company_increase_value_profits"],
        shopperDeliveryProfits: json["shopper_delivery_profits"] == null ? null : json["shopper_delivery_profits"],
        companyDeliveryProfits: json["company_delivery_profits"] == null ? null : json["company_delivery_profits"],
        companyDeliveryMethodProfits:
            json["company_delivery_method_profits"] == null ? null : json["company_delivery_method_profits"],
      );

  Map<String, dynamic> toJson() => {
        "total_shopping_profits": totalShoppingProfits == null ? null : totalShoppingProfits,
        "shopper_shopping_profits": shopperShoppingProfits == null ? null : shopperShoppingProfits,
        "company_shopping_profits": companyShoppingProfits == null ? null : companyShoppingProfits,
        "shopper_increase_value_profits": shopperIncreaseValueProfits == null ? null : shopperIncreaseValueProfits,
        "company_increase_value_profits": companyIncreaseValueProfits == null ? null : companyIncreaseValueProfits,
        "shopper_delivery_profits": shopperDeliveryProfits == null ? null : shopperDeliveryProfits,
        "company_delivery_profits": companyDeliveryProfits == null ? null : companyDeliveryProfits,
        "company_delivery_method_profits":
            companyDeliveryMethodProfits == null ? null : companyDeliveryMethodProfits,
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
        "from_date": fromDate == null ? null : fromDate.toIso8601String(),
        "to_date": toDate == null ? null : toDate.toIso8601String(),
      };
}

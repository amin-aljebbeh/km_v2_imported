// To parse this JSON data, do
//
//     final financialReport = financialReportFromJson(jsonString);الأرباح والمستحقات المالية

import 'dart:convert';

FinancialReport financialReportFromJson(String str) => FinancialReport.fromJson(json.decode(str));

String financialReportToJson(FinancialReport data) => json.encode(data.toJson());

class FinancialReport {
  FinancialReport({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory FinancialReport.fromJson(Map<String, dynamic> json) => FinancialReport(
        success: json['success'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.toJson(),
      };
}

class Data {
  Data({
    this.general,
    this.warehouses,
  });

  General general;
  List<FinancialWarehouse> warehouses;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        general: General.fromJson(json['general']),
        warehouses: List<FinancialWarehouse>.from(json['warehouses'].map((x) => FinancialWarehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'general': general.toJson(),
        'warehouses': List<dynamic>.from(warehouses.map((x) => x.toJson())),
      };
}

class General {
  General({
    this.totalCompanyDues,
    this.totalProfitsShoppers,
  });

  int totalCompanyDues;
  int totalProfitsShoppers;

  factory General.fromJson(Map<String, dynamic> json) => General(
        totalCompanyDues: json['total_company_dues'],
        totalProfitsShoppers: json['total_profits_shoppers'],
      );

  Map<String, dynamic> toJson() => {
        'total_company_dues': totalCompanyDues,
        'total_profits_shoppers': totalProfitsShoppers,
      };
}

class FinancialWarehouse {
  FinancialWarehouse({
    this.id,
    this.name,
    this.totalCompanyDues,
    this.totalProfitsShoppers,
    this.shoppers,
  });

  int id;
  String name;
  int totalCompanyDues;
  int totalProfitsShoppers;
  List<Shopper> shoppers;

  factory FinancialWarehouse.fromJson(Map<String, dynamic> json) => FinancialWarehouse(
        id: json['id'],
        name: json['name'],
        totalCompanyDues: json['total_company_dues'],
        totalProfitsShoppers: json['total_profits_shoppers'],
        shoppers: List<Shopper>.from(json['shoppers'].map((x) => Shopper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'total_company_dues': totalCompanyDues,
        'total_profits_shoppers': totalProfitsShoppers,
        'shoppers': List<dynamic>.from(shoppers.map((x) => x.toJson())),
      };
}

class Shopper {
  Shopper({
    this.shopperId,
    this.name,
    this.companyDues,
    this.totalProfits,
    this.avgDeliveryMinutes,
    this.avgOrderRating,
  });

  int shopperId;
  String name;
  String companyDues;
  String totalProfits;
  String avgDeliveryMinutes;
  String avgOrderRating;

  factory Shopper.fromJson(Map<String, dynamic> json) => Shopper(
        shopperId: json['shopper_id'],
        name: json['name'],
        companyDues: json['company_dues'],
        totalProfits: json['total_profits'],
        avgDeliveryMinutes: json['avg_delivery_minutes'],
        avgOrderRating: json['avg_order_rating'],
      );

  Map<String, dynamic> toJson() => {
        'shopper_id': shopperId,
        'name': name,
        'company_dues': companyDues,
        'total_profits': totalProfits,
        'avg_delivery_minutes': avgDeliveryMinutes,
        'avg_order_rating': avgOrderRating,
      };
}

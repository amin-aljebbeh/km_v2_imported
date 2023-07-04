import 'dart:convert';

import '../../domain/entities/shopper_monthly_report_entity.dart';

ShopperMonthlyReportResponse shopperMonthlyReportFromJson(String str) =>
    ShopperMonthlyReportResponse.fromJson(json.decode(str));

String shopperMonthlyReportToJson(ShopperMonthlyReportResponse data) => json.encode(data.toJson());

class ShopperMonthlyReportResponse {
  ShopperMonthlyReportResponse({this.success, this.shopperMonthlyReport});

  bool success;
  List<ShopperMonthlyReportModel> shopperMonthlyReport;

  factory ShopperMonthlyReportResponse.fromJson(Map<String, dynamic> json) => ShopperMonthlyReportResponse(
        success: json['success'],
        shopperMonthlyReport:
            List<ShopperMonthlyReportModel>.from(json['reason'].map((x) => ShopperMonthlyReportModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {'success': success, 'reason': List<dynamic>.from(shopperMonthlyReport.map((x) => x.toJson()))};
}

class ShopperMonthlyReportModel extends ShopperMonthlyReportEntity {
  ShopperMonthlyReportModel({date, countOrder, monthlyProfit, sumDistances})
      : super(date: date, countOrder: countOrder, monthlyProfit: monthlyProfit, sumDistances: sumDistances);

  factory ShopperMonthlyReportModel.fromJson(Map<String, dynamic> json) => ShopperMonthlyReportModel(
      date: json['date'].toString(),
      countOrder: json['count_order'] == null ? '0' : json['count_order'].toString(),
      monthlyProfit: json['monthly_profit'] == null ? '0' : json['monthly_profit'].toString(),
      sumDistances: json['sum_distances'] == null ? '0' : json['sum_distances'].toString());

  Map<String, dynamic> toJson() => {'date': date, 'count_order': countOrder, 'monthly_profit': monthlyProfit};
}

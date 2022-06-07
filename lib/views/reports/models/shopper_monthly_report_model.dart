import 'dart:convert';

ShopperMonthlyReportResponse shopperMonthlyReportFromJson(String str) =>
    ShopperMonthlyReportResponse.fromJson(json.decode(str));

String shopperMonthlyReportToJson(ShopperMonthlyReportResponse data) => json.encode(data.toJson());

class ShopperMonthlyReportResponse {
  ShopperMonthlyReportResponse({
    this.success,
    this.shopperMonthlyReport,
  });

  bool success;
  List<ShopperMonthlyReport> shopperMonthlyReport;

  factory ShopperMonthlyReportResponse.fromJson(Map<String, dynamic> json) => ShopperMonthlyReportResponse(
        success: json['success'],
        shopperMonthlyReport:
            List<ShopperMonthlyReport>.from(json['reason'].map((x) => ShopperMonthlyReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'reason': List<dynamic>.from(shopperMonthlyReport.map((x) => x.toJson())),
      };
}

class ShopperMonthlyReport {
  ShopperMonthlyReport({
    this.date,
    this.countOrder,
    this.monthlyProfit,
  });

  String date;
  int countOrder;
  String monthlyProfit;

  factory ShopperMonthlyReport.fromJson(Map<String, dynamic> json) => ShopperMonthlyReport(
        date: json['date'],
        countOrder: json['count_order'] ?? 0,
        monthlyProfit: json['monthly_profit'] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'count_order': countOrder,
        'monthly_profit': monthlyProfit,
      };
}

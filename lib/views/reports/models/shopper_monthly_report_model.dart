import 'dart:convert';

ShopperMonthlyReportResponse shopperMonthlyReportFromJson(String str) =>
    ShopperMonthlyReportResponse.fromJson(json.decode(str));

String shopperMonthlyReportToJson(ShopperMonthlyReportResponse data) => json.encode(data.toJson());

class ShopperMonthlyReportResponse {
  ShopperMonthlyReportResponse({this.success, this.shopperMonthlyReport});

  bool success;
  List<ShopperMonthlyReport> shopperMonthlyReport;

  factory ShopperMonthlyReportResponse.fromJson(Map<String, dynamic> json) => ShopperMonthlyReportResponse(
        success: json['success'],
        shopperMonthlyReport:
            List<ShopperMonthlyReport>.from(json['reason'].map((x) => ShopperMonthlyReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {'success': success, 'reason': List<dynamic>.from(shopperMonthlyReport.map((x) => x.toJson()))};
}

class ShopperMonthlyReport {
  ShopperMonthlyReport({this.date, this.countOrder, this.monthlyProfit, this.sumDistances});

  String date;
  String countOrder;
  String monthlyProfit;
  String sumDistances;

  factory ShopperMonthlyReport.fromJson(Map<String, dynamic> json) => ShopperMonthlyReport(
      date: json['date'].toString(),
      countOrder: json['count_order'] == null ? '0' : json['count_order'].toString(),
      monthlyProfit: json['monthly_profit'] == null ? '0' : json['monthly_profit'].toString(),
      sumDistances: json['sum_distances'] == null ? '0' : json['sum_distances'].toString());

  Map<String, dynamic> toJson() => {'date': date, 'count_order': countOrder, 'monthly_profit': monthlyProfit};
}

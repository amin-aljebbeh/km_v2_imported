// To parse this JSON data, do
//
//     final monthlyProfit = monthlyProfitFromJson(jsonString);

import 'dart:convert';

MonthlyProfit monthlyProfitFromJson(String str) => MonthlyProfit.fromJson(json.decode(str));

String monthlyProfitToJson(MonthlyProfit data) => json.encode(data.toJson());

class MonthlyProfit {
  MonthlyProfit({
    this.success,
    this.profit,
    this.countOrderThisMonth,
    this.workingHour,
    this.avgOrderRating,
    this.avgDeliveryMinutes,
  });

  bool success;
  String profit;
  int countOrderThisMonth;
  double workingHour;
  String avgOrderRating;
  String avgDeliveryMinutes;

  factory MonthlyProfit.fromJson(Map<String, dynamic> json) => MonthlyProfit(
        success: json['success'],
        profit: json['data'].toString(),
        countOrderThisMonth: json['count_order_this_month'],
        workingHour: json['working_hour'] == null ? 0.0.toDouble() : json['working_hour'].toDouble(),
        avgOrderRating: json['avg_order_rating'],
        avgDeliveryMinutes: json['avg_delivery_minutes'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': profit,
        'count_order_this_month': countOrderThisMonth,
        'working_hour': workingHour,
        'avg_order_rating': avgOrderRating,
        'avg_delivery_minutes': avgDeliveryMinutes,
      };
}

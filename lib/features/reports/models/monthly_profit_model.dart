// To parse this JSON data, do
//
//     final monthlyProfit = monthlyProfitFromJson(jsonString);

import 'dart:convert';

MonthlyProfit monthlyProfitFromJson(String str) => MonthlyProfit.fromJson(json.decode(str));

class MonthlyProfit {
  MonthlyProfit({
    this.success,
    this.monthlyProfits,
    this.countOrderThisMonth,
    this.workingHour,
    this.avgOrderRating,
    this.avgDeliveryMinutes,
    this.deliveryDistance,
    this.dailyProfits,
  });

  bool success;
  int monthlyProfits;
  int dailyProfits;
  int countOrderThisMonth;
  String workingHour;
  String avgOrderRating;
  String avgDeliveryMinutes;
  String deliveryDistance;

  factory MonthlyProfit.fromJson(Map<String, dynamic> json) => MonthlyProfit(
        success: json['success'],
        monthlyProfits: json['monthly_profits'],
        dailyProfits: json['daily_profits'],
        countOrderThisMonth: json['count_order_this_month'],
        workingHour: json['working_hour'] == null ? '0' : json['working_hour'].toString(),
        avgOrderRating: json['avg_order_rating'],
        avgDeliveryMinutes: json['avg_delivery_minutes'],
        deliveryDistance: json['sum_distances'] == null ? '0' : json['sum_distances'].toString(),
      );
}

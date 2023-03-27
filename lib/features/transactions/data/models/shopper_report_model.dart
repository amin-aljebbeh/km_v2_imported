// To parse this JSON data, do
//
//     final monthlyProfit = monthlyProfitFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/features/transactions/domain/entities/shopper_report_entity.dart';

ShopperReportModel monthlyProfitFromJson(String str) => ShopperReportModel.fromJson(json.decode(str));

class ShopperReportModel extends ShopperReportEntity {
  ShopperReportModel({
    success,
    monthlyProfits,
    countOrderThisMonth,
    workingHour,
    avgOrderRating,
    avgDeliveryMinutes,
    deliveryDistance,
    dailyProfits,
  }) : super(
          success: success,
          monthlyProfits: monthlyProfits,
          countOrderThisMonth: countOrderThisMonth,
          workingHour: workingHour,
          avgOrderRating: avgOrderRating,
          avgDeliveryMinutes: avgDeliveryMinutes,
          deliveryDistance: deliveryDistance,
          dailyProfits: dailyProfits,
        );

  factory ShopperReportModel.fromJson(Map<String, dynamic> json) => ShopperReportModel(
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

// To parse this JSON data, do
//
//     final monthlyProfit = monthlyProfitFromJson(jsonString);

import 'package:kammun_app/features/transactions/domain/entities/shopper_report_entity.dart';

import '../../../../core/core_importer.dart';

ShopperReportResponseModel shopperReportResponseModelFromJson(String str) =>
    ShopperReportResponseModel.fromJson(json.decode(str));

class ShopperReportResponseModel {
  ShopperReportResponseModel({this.success, this.report});

  bool success;
  ShopperReportModel report;

  factory ShopperReportResponseModel.fromJson(Map<String, dynamic> json) =>
      ShopperReportResponseModel(success: json['success'], report: ShopperReportModel.fromJson(json['data']));
}

class ShopperReportModel extends ShopperReportEntity {
  ShopperReportModel({
    monthlyProfits,
    countOrderThisMonth,
    workingHour,
    avgOrderRating,
    avgDeliveryMinutes,
    deliveryDistance,
    dailyProfits,
  }) : super(
          monthlyProfits: monthlyProfits,
          countOrderThisMonth: countOrderThisMonth,
          workingHour: workingHour,
          avgOrderRating: avgOrderRating,
          avgDeliveryMinutes: avgDeliveryMinutes,
          deliveryDistance: deliveryDistance,
          dailyProfits: dailyProfits,
        );

  factory ShopperReportModel.fromJson(Map<String, dynamic> json) {
    Tools.logToConsole(';;');
    Tools.logToConsole(json['avg_delivery_minutes']);
    Tools.logToConsole(json['avg_order_rating'] == null);
    return ShopperReportModel(
      monthlyProfits: json['monthly_profits'] == null ? '0' : json['monthly_profits'].toString(),
      dailyProfits: json['daily_profits'] == null ? '0' : json['daily_profits'].toString(),
      countOrderThisMonth: json['count_order_this_month'] == null ? '0' : json['count_order_this_month'].toString(),
      workingHour: json['working_hour'] == null ? '0' : json['working_hour'].toString(),
      avgOrderRating: json['avg_order_rating'] == null ? '0' : json['avg_order_rating'].toString(),
      avgDeliveryMinutes: json['avg_delivery_minutes'] == null ? '0' : json['avg_delivery_minutes'].toString(),
      deliveryDistance: json['sum_distances'] == null ? '0' : json['sum_distances'].toString(),
    );
  }
}

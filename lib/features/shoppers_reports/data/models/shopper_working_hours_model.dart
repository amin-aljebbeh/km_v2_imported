// To parse this JSON data, do
//
//     final shopperWorkingHours = shopperWorkingHoursFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/shopper_working_hours_entity.dart';

ShopperWorkingHours shopperWorkingHoursFromJson(String str) => ShopperWorkingHours.fromJson(json.decode(str));

String shopperWorkingHoursToJson(ShopperWorkingHours data) => json.encode(data.toJson());

class ShopperWorkingHours {
  ShopperWorkingHours({
    this.success,
    this.data,
  });

  bool success;
  List<ShopperWorkingHoursModel> data;

  factory ShopperWorkingHours.fromJson(Map<String, dynamic> json) => ShopperWorkingHours(
        success: json['success'],
        data: List<ShopperWorkingHoursModel>.from(json['data'].map((x) => ShopperWorkingHoursModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {'success': success, 'data': List<dynamic>.from(data.map((x) => x.toJson()))};
}

class ShopperWorkingHoursModel extends ShopperWorkingHoursEntity {
  ShopperWorkingHoursModel({date, sum, countOrders, sumDistances})
      : super(date: date, sum: sum, countOrders: countOrders, sumDistances: sumDistances);

  factory ShopperWorkingHoursModel.fromJson(Map<String, dynamic> json) => ShopperWorkingHoursModel(
      date: json['date'].toString(),
      sum: json['sum'] == null ? '0' : json['sum'].toString(),
      countOrders: json['count_orders'] == null ? '0' : json['count_orders'].toString(),
      sumDistances: json['sum_distances'] == null ? '0' : json['sum_distances'].toString());

  Map<String, dynamic> toJson() => {'date': date, 'sum': sum};
}

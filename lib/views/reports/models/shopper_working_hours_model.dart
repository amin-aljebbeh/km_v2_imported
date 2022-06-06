// To parse this JSON data, do
//
//     final shopperWorkingHours = shopperWorkingHoursFromJson(jsonString);

import 'dart:convert';

ShopperWorkingHours shopperWorkingHoursFromJson(String str) => ShopperWorkingHours.fromJson(json.decode(str));

String shopperWorkingHoursToJson(ShopperWorkingHours data) => json.encode(data.toJson());

class ShopperWorkingHours {
  ShopperWorkingHours({
    this.success,
    this.data,
  });

  bool success;
  List<ShopperWorkingHoursData> data;

  factory ShopperWorkingHours.fromJson(Map<String, dynamic> json) => ShopperWorkingHours(
        success: json['success'],
        data: List<ShopperWorkingHoursData>.from(json['data'].map((x) => ShopperWorkingHoursData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ShopperWorkingHoursData {
  ShopperWorkingHoursData({this.date, this.sum});

  String date;
  double sum;

  factory ShopperWorkingHoursData.fromJson(Map<String, dynamic> json) => ShopperWorkingHoursData(
        date: json['date'],
        sum: json['sum'].toDouble(),
      );

  Map<String, dynamic> toJson() => {'date': date, 'sum': sum};
}

// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

DailyProfitModel dailyProfitModelFromJson(String str) =>
    DailyProfitModel.fromJson(json.decode(str));

String dailyProfitModelToJson(DailyProfitModel data) =>
    json.encode(data.toJson());

class DailyProfitModel {
  DailyProfitModel({
    this.success,
    this.profit,
  });

  bool success;
  String profit;

  factory DailyProfitModel.fromJson(Map<String, dynamic> json) =>
      DailyProfitModel(
        success: json["success"] == null ? null : json["success"],
        profit: json["data"] == null ? null : json["data"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": profit == null ? null : profit,
      };
}

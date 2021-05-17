// To parse this JSON data, do
//
//     final getDailyStatistics = getDailyStatisticsFromJson(jsonString);

import 'dart:convert';

GetDailyStatistics getDailyStatisticsFromJson(String str) =>
    GetDailyStatistics.fromJson(json.decode(str));

String getDailyStatisticsToJson(GetDailyStatistics data) =>
    json.encode(data.toJson());

class GetDailyStatistics {
  GetDailyStatistics({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory GetDailyStatistics.fromJson(Map<String, dynamic> json) =>
      GetDailyStatistics(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.vegetables,
    this.toaster,
    this.dataLibrary,
    this.seed,
    this.all,
  });

  int vegetables;
  int toaster;
  int dataLibrary;
  int seed;
  int all;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        vegetables: json["Vegetables"],
        toaster: json["Toaster"],
        dataLibrary: json["Library"],
        seed: json["Seed"],
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "Vegetables": vegetables,
        "Toaster": toaster,
        "Library": dataLibrary,
        "Seed": seed,
        "all": all,
      };
}

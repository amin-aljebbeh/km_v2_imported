// To parse this JSON data, do
//
//     final polygon = polygonFromJson(jsonString);

import 'dart:convert';

List<PolygonModel> polygonFromJson(String str) =>
    List<PolygonModel>.from(json.decode(str).map((x) => PolygonModel.fromJson(x)));

String polygonToJson(List<PolygonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PolygonModel {
  PolygonModel({
    this.supportedCityName,
    this.supportedCityId,
    this.polygonPoints,
  });

  String supportedCityName;
  String supportedCityId;
  List<List<double>> polygonPoints;

  factory PolygonModel.fromJson(Map<String, dynamic> json) => PolygonModel(
        supportedCityName: json["supported_city_name"],
        supportedCityId: json["supported_city_id"],
        polygonPoints: json["polygon"] == null
            ? null
            : List<List<double>>.from(json["polygon"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "supported_city_name": supportedCityName,
        "supported_city_id": supportedCityId,
        "polygon": polygonPoints == null
            ? null
            : List<dynamic>.from(polygonPoints.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

import 'dart:convert';

import 'package:kammun_app/models/supported_city.dart';

import 'sub_warehouse_model.dart';

Level levelFromJson(String str) => Level.fromJson(json.decode(str));

class Level {
  Level({
    this.id,
    this.name,
    this.description,
    this.maxProductsToHandle,
    this.maxOrdersToHandle,
    this.maxCompanyBalance,
    this.points,
    this.createdAt,
    this.updatedAt,
    this.subWarehouses,
    this.supportedCities,
  });

  int id;
  String name;
  dynamic description;
  int maxProductsToHandle;
  int maxOrdersToHandle;
  int maxCompanyBalance;
  int points;
  DateTime createdAt;
  dynamic updatedAt;
  List<SubWarehouse> subWarehouses;
  List<SupportedCity> supportedCities;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"],
        maxProductsToHandle: json["max_products_to_handle"] == null ? null : json["max_products_to_handle"],
        maxOrdersToHandle: json["max_orders_to_handle"] == null ? null : json["max_orders_to_handle"],
        maxCompanyBalance: json["max_company_balance"] == null ? null : json["max_company_balance"],
        points: json["points"] == null ? null : json["points"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        subWarehouses: json["sub_warehouses"] == null
            ? []
            : List<SubWarehouse>.from(json["sub_warehouses"].map((x) => SubWarehouse.fromJson(x))),
        supportedCities: json["supported_cities"] == null
            ? null
            : List<SupportedCity>.from(json["supported_cities"].map((x) => SupportedCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description,
        "max_products_to_handle": maxProductsToHandle == null ? null : maxProductsToHandle,
        "max_orders_to_handle": maxOrdersToHandle == null ? null : maxOrdersToHandle,
        "points": points == null ? null : points,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}

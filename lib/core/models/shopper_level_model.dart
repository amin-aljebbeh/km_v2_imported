import 'dart:convert';

import 'package:kammun_app/core/models/supported_city.dart';

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
    this.pricePerKilo,
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
  String pricePerKilo;
  List<SubWarehouse> subWarehouses;
  List<SupportedCity> supportedCities;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        maxProductsToHandle: json['max_products_to_handle'],
        maxOrdersToHandle: json['max_orders_to_handle'],
        maxCompanyBalance: json['max_company_balance'],
        points: json['points'],
        pricePerKilo: json['price_per_kilo'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'],
        subWarehouses: json['sub_warehouses'] == null
            ? []
            : List<SubWarehouse>.from(json['sub_warehouses'].map((x) => SubWarehouse.fromJson(x))),
        supportedCities: json['supported_cities'] == null
            ? null
            : List<SupportedCity>.from(json['supported_cities'].map((x) => SupportedCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'max_products_to_handle': maxProductsToHandle,
        'max_orders_to_handle': maxOrdersToHandle,
        'points': points,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt,
      };
}

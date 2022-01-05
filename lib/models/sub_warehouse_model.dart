// To parse this JSON data, do
//
//     final subWarehouse = subWarehouseFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/views/loading/LoadingServices.dart';

import 'models_importer.dart';

List<SubWarehouse> subWarehouseFromJson(String str) => List<SubWarehouse>.from(
    json.decode(str).map((x) => SubWarehouse.fromJson(x)));

String subWarehouseToJson(List<SubWarehouse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubWarehouse {
  SubWarehouse({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.businessDomain,
    this.accountingSystemId,
    this.warehouseId,
    this.adminPivot,
    this.levelPivot,
    this.discountPercentage,
  });

  int id;
  String name;
  String description;
  String phone;
  String businessDomain;
  int accountingSystemId;
  int warehouseId;
  SubWarehouseAdminPivot adminPivot;
  SubWarehouseLevelPivot levelPivot;
  double discountPercentage;

  static double getDiscountPercentage(int subWarehouseId) {
    return (LoadingScreenServices.subWarehouses
            .firstWhere((subWarehouse) => subWarehouse.id == subWarehouseId)
            .discountPercentage /
        100);
  }

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        phone: json["phone"] == null ? null : json["phone"],
        businessDomain:
            json["business_domain"] == null ? null : json["business_domain"],
        accountingSystemId: json["accounting_system_id"] == null
            ? null
            : json["accounting_system_id"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        adminPivot: json["pivot"]["admin_id"] == null
            ? null
            : SubWarehouseAdminPivot.fromJson(json["pivot"]),
        levelPivot: json["pivot"]["level_id"] == null
            ? null
            : SubWarehouseLevelPivot.fromJson(json["pivot"]),
        discountPercentage: json["discount_percentage"] == null
            ? null
            : double.parse(json["discount_percentage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "phone": phone == null ? null : phone,
        "business_domain": businessDomain == null ? null : businessDomain,
        "accounting_system_id":
            accountingSystemId == null ? null : accountingSystemId,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "pivot": adminPivot == null
            ? levelPivot == null
                ? null
                : levelPivot.toJson()
            : adminPivot.toJson(),
        "discount_percentage":
            discountPercentage == null ? null : discountPercentage,
      };
}

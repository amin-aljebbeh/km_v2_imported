// To parse this JSON data, do
//
//     final subWarehouse = subWarehouseFromJson(jsonString);

import 'dart:convert';

List<SubWarehouse> subWarehouseFromJson(String str) => List<SubWarehouse>.from(
    json.decode(str).map((x) => SubWarehouse.fromJson(x)));

String subWarehouseToJson(List<SubWarehouse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubWarehouse {
  SubWarehouse({
    this.id,
    this.name,
    this.description,
    this.businessDomain,
    this.warehouseId,
    this.pivot,
  });

  int id;
  String name;
  String description;
  String businessDomain;
  int warehouseId;
  Pivot pivot;

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        businessDomain:
            json["business_domain"] == null ? null : json["business_domain"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "business_domain": businessDomain == null ? null : businessDomain,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    this.adminId,
    this.subWarehouseId,
  });

  int adminId;
  int subWarehouseId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "sub_warehouse_id": subWarehouseId == null ? null : subWarehouseId,
      };
}

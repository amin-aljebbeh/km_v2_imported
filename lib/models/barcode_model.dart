// To parse this JSON data, do
//
//     final barcode = barcodeFromJson(jsonString);

// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

Barcode barcodeFromJson(String str) => Barcode.fromJson(json.decode(str));

String barcodeToJson(Barcode data) => json.encode(data.toJson());

class Barcode {
  Barcode({this.productId, this.barcode, this.warehouseId, this.updatedAt, this.createdAt, this.id});

  String productId;
  String barcode;
  String warehouseId;
  DateTime updatedAt;
  DateTime createdAt;
  String id;

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      productId: json["product_id"] == null ? '0' : json["product_id"].toString(),
      barcode: json["barcode"] == null ? 'null' : json["barcode"].toString(),
      warehouseId: json["warehouse_id"] == null ? '0' : json["warehouse_id"].toString(),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      id: json["id"] == null ? '0' : json["id"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "barcode": barcode,
        "warehouse_id": warehouseId,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "id": id,
      };
}

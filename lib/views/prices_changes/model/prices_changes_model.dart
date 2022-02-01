// To parse this JSON data, do
//
//     final pricesChanges = pricesChangesFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/models/models_importer.dart';

PricesChanges pricesChangesFromJson(String str) => PricesChanges.fromJson(json.decode(str));

String pricesChangesToJson(PricesChanges data) => json.encode(data.toJson());

class PricesChanges {
  PricesChanges({
    this.success,
    this.count,
    this.productsPriceChange,
  });

  bool success;
  int count;
  List<ProductData> productsPriceChange;

  factory PricesChanges.fromJson(Map<String, dynamic> json) => PricesChanges(
        success: json["success"],
        count: json["count"],
        productsPriceChange:
            List<ProductData>.from(json["proucts_price_change"].map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "proucts_price_change": List<dynamic>.from(productsPriceChange.map((x) => x.toJson())),
      };
}

class ProductsPriceChange {
  ProductsPriceChange({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.quantity,
    this.productId,
    this.warehouseId,
    this.price,
    this.isActive,
    this.isFeatured,
    this.priority,
    this.numberOfVisits,
    this.supplierCode,
    this.minThreshold,
    this.increasePercentage,
    this.priceFactor,
    this.underCheckAvailability,
    this.priceChange,
    this.updateAt,
    this.images,
  });

  int id;
  String name;
  String description;
  String unit;
  int quantity;
  int productId;
  int warehouseId;
  String price;
  int isActive;
  int isFeatured;
  int priority;
  int numberOfVisits;
  String supplierCode;
  double minThreshold;
  String increasePercentage;
  String priceFactor;
  int underCheckAvailability;
  String priceChange;
  DateTime updateAt;
  List<Image> images;

  factory ProductsPriceChange.fromJson(Map<String, dynamic> json) => ProductsPriceChange(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        unit: json["unit"],
        quantity: json["quantity"],
        productId: json["product_id"],
        warehouseId: json["warehouse_id"],
        price: json["price"],
        isActive: json["is_active"],
        isFeatured: json["is_featured"],
        priority: json["priority"],
        numberOfVisits: json["number_of_visits"],
        supplierCode: json["supplier_code"],
        minThreshold: json["min_threshold"].toDouble(),
        increasePercentage: json["increase_percentage"],
        priceFactor: json["price_factor"],
        underCheckAvailability: json["under_check_availability"],
        priceChange: json["price_change"],
        updateAt: DateTime.parse(json["update_at"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "quantity": quantity,
        "product_id": productId,
        "warehouse_id": warehouseId,
        "price": price,
        "is_active": isActive,
        "is_featured": isFeatured,
        "priority": priority,
        "number_of_visits": numberOfVisits,
        "supplier_code": supplierCode,
        "min_threshold": minThreshold,
        "increase_percentage": increasePercentage,
        "price_factor": priceFactor,
        "under_check_availability": underCheckAvailability,
        "price_change": priceChange,
        "update_at": updateAt.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class Image {
  Image({
    this.id,
    this.productId,
    this.imageFileName,
  });

  int id;
  int productId;
  String imageFileName;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        productId: json["product_id"],
        imageFileName: json["image_file_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "image_file_name": imageFileName,
      };
}

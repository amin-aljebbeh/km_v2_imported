import 'dart:convert';

import 'start_model_importer.dart';

CategoryOriginal categoryOriginalFromJson(String str) => CategoryOriginal.fromJson(json.decode(str));

class Category {
  Category({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  CategoryOriginal original;
  dynamic exception;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        headers: Headers.fromJson(json["headers"]),
        original: CategoryOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class CategoryOriginal {
  CategoryOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<CategoryOriginalData> data;

  factory CategoryOriginal.fromJson(Map<String, dynamic> json) => CategoryOriginal(
        success: json["success"],
        data: List<CategoryOriginalData>.from(json["data"].map((x) => CategoryOriginalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoryOriginalData {
  CategoryOriginalData({
    this.id,
    this.name,
    this.imageFileName,
    this.parentCategoryId,
    this.isCompany,
    this.warehouses,
  });

  int id;
  String name;
  String imageFileName;
  String parentCategoryId;
  String isCompany;
  List<Warehouse> warehouses;

  factory CategoryOriginalData.fromJson(Map<String, dynamic> json) => CategoryOriginalData(
        id: json["id"],
        name: json["name"],
        imageFileName: json["image_file_name"],
        parentCategoryId: json["parent_category_id"].toString(),
        isCompany: json["is_company"].toString(),
        warehouses: json["warehouses"] == null
            ? null
            : List<Warehouse>.from(json["warehouses"].map((x) => Warehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_file_name": imageFileName,
        "parent_category_id": parentCategoryId,
        "is_company": isCompany,
        "warehouses": List<dynamic>.from(warehouses.map((x) => x.toJson())),
      };
}

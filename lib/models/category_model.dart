import 'models_importer.dart';

class Category {
  Category({
    this.headers,
    this.original,
  });

  Headers headers;
  CategoryOriginal original;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        headers: Headers.fromJson(json["headers"]),
        original: CategoryOriginal.fromJson(json["original"]),
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
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
        parentCategoryId: (json["parent_category_id"] ?? json["parent_category_id"]).toString(),
        isCompany: json["is_company"].toString(),
        warehouses: List<Warehouse>.from(json["warehouses"].map((x) => Warehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_file_name": imageFileName,
        "parent_category_id": parentCategoryId ?? parentCategoryId,
        "is_company": isCompany,
        "warehouses": List<dynamic>.from(warehouses.map((x) => x.toJson())),
      };
}

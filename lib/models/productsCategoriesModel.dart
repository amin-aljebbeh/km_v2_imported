// To parse this JSON data, do
//
//     final categoryProduct = categoryProductFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/models/start_model.dart';

CategoryProduct categoryProductFromJson(String str) =>
    CategoryProduct.fromJson(json.decode(str));

List<ProductsData> syncCartFromJson(String str) => List<ProductsData>.from(
    json.decode(str).map((x) => ProductsData.fromJson(x)));

String categoryProductToJson(CategoryProduct data) =>
    json.encode(data.toJson());

class CategoryProduct {
  CategoryProduct({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory CategoryProduct.fromJson(Map<String, dynamic> json) =>
      CategoryProduct(
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
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<ProductsData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<ProductsData>.from(
            json["data"].map((x) => ProductsData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class ProductsData {
  ProductsData(
      {this.id,
      this.name,
      this.description,
      this.unit,
      this.isInFacebook,
      this.categoryId,
      this.warehouses,
      this.images,
      this.productCount,
      this.quantity});

  int id;
  String name;
  String description;
  String unit;
  String isInFacebook;
  String categoryId;
  String quantity;
  int productCount;

  List<Warehouse> warehouses;
  List<ProductImage> images;

  factory ProductsData.fromJson(Map<String, dynamic> json) {
    List<ProductImage> images = new List<ProductImage>();

    return ProductsData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      unit: json["unit"],
      isInFacebook: json["is_in_facebook"],
      categoryId: json["category_id"],
      quantity: json["quantity"],
      warehouses: List<Warehouse>.from(
          json["warehouses"].map((x) => Warehouse.fromJson(x))),
      images: json["images"] == null
          ? images
          : List<ProductImage>.from(
              json["images"].map((x) => ProductImage.fromJson(x))),
      productCount: json["productCount"],
      // images: List<ProductImage>.from(
      //     json["images"].map((x) => ProductImage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "is_in_facebook": isInFacebook,
        "category_id": categoryId,
        "quantity": quantity,
        "warehouses": List<dynamic>.from(warehouses.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "productCount": productCount,
      };
}

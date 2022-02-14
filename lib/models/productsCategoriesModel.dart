import 'dart:convert';
import 'package:kammun_app/models/models_importer.dart';

CategoryProduct categoryProductFromJson(String str) => CategoryProduct.fromJson(json.decode(str));

String categoryProductToJson(CategoryProduct data) => json.encode(data.toJson());

List<ProductData> syncCartFromJson(String str) =>
    List<ProductData>.from(json.decode(str).map((x) => ProductData.fromJson(x)));

ProductResponse favoritesProductFromJson(String str) => ProductResponse.fromJson(json.decode(str));

// CategoryProduct publicParameterFromJson(String str) =>
//     CategoryProduct.fromJson(json.decode(str));

class CategoryProduct {
  CategoryProduct({
    this.success,
    this.data,
  });

  bool success;
  ProductResponse data;

  factory CategoryProduct.fromJson(Map<String, dynamic> json) => CategoryProduct(
        success: json["success"],
        data: ProductResponse.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class ProductResponse {
  ProductResponse({
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
  List<ProductData> data;
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

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      currentPage: json["current_page"],
      data: List<ProductData>.from(json["data"].map((x) => x == null ? null : ProductData.fromJson(x))),
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
  }

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x == null ? null : x.toJson())),
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

class ProductData {
  ProductData({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.categoryId,
    this.price,
    this.isActive,
    this.quantity,
    this.productCount,
    this.images,
  });

  int id;
  String name;
  String description;
  String unit;
  String categoryId;
  String price;
  String isActive;
  String quantity;
  int productCount;
  List<ProductImage> images;

  factory ProductData.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return ProductData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      unit: json["unit"] == null ? 'null' : json['unit'],
      categoryId: json["category_id"].toString(),
      price: json["price"].toString(),
      isActive: json["is_active"].toString(),
      quantity: json["quantity"].toString(),
      productCount: json["productCount"],
      images: List<ProductImage>.from(json["images"].map((x) => ProductImage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "category_id": categoryId,
        "price": price,
        "is_active": isActive,
        "quantity": quantity,
        "productCount": productCount,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

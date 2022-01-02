import 'dart:convert';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/models/start_models/category_model.dart';
import 'package:kammun_app/models/start_models/warehouse_model.dart';

import 'start_models/order_product_model.dart';

CategoryProduct categoryProductFromJson(String str) =>
    CategoryProduct.fromJson(json.decode(str));

String categoryProductToJson(CategoryProduct data) =>
    json.encode(data.toJson());

List<ProductData> syncCartFromJson(String str) => List<ProductData>.from(
    json.decode(str).map((x) => ProductData.fromJson(x)));

ProductResponse favoritesProductFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

// CategoryProduct publicParameterFromJson(String str) =>
//     CategoryProduct.fromJson(json.decode(str));

class CategoryProduct {
  CategoryProduct({
    this.success,
    this.data,
  });

  bool success;
  ProductResponse data;

  factory CategoryProduct.fromJson(Map<String, dynamic> json) =>
      CategoryProduct(
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
      data: List<ProductData>.from(
          json["data"].map((x) => x == null ? null : ProductData.fromJson(x))),
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
        "data":
            List<dynamic>.from(data.map((x) => x == null ? null : x.toJson())),
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
    this.price,
    this.isActive,
    this.quantity,
    this.productCount,
    this.images,
    this.supplierCode,
    this.warehouseId,
    this.isFeatured,
    this.underCheckAvailability,
    this.priceFactor,
    this.increasePercentage,
    this.minThreshold,
    this.numberOfVisits,
    this.priority,
    this.subWarehouseId,
    this.priceChange,
    this.categories,
    this.warehouses,
    this.automaticActivation,
  });

  int id;
  String name;
  String description;
  String unit;
  String price;
  String isActive;
  String quantity;
  int productCount;
  List<ProductImage> images;
  String supplierCode;
  List<CategoryOriginalData> categories;
  List<Warehouse> warehouses;

  //////

  int warehouseId;
  int isFeatured;
  int priority;
  int numberOfVisits;
  double minThreshold;
  int increasePercentage;
  String priceFactor;
  int underCheckAvailability;
  int subWarehouseId;
  String priceChange;
  int automaticActivation;

  factory ProductData.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    ProductData productData = ProductData(
      id: json["id"] == null ? json["product_id"] : json["id"],
      name: json["name"],
      description: json["description"],
      unit: json["unit"].toString(),
      price: json["price"].toString(),
      priceChange:
          json["price_change"] == null ? null : json["price_change"].toString(),
      isActive: json["is_active"].toString(),
      quantity: json["quantity"],
      productCount: json["productCount"],
      supplierCode:
          json["supplier_code"] == null ? null : json["supplier_code"],
      warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
      subWarehouseId:
          json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
      isFeatured: json["is_featured"] == null ? null : json["is_featured"],
      priority: json["priority"] == null ? null : json["priority"],
      numberOfVisits:
          json["number_of_visits"] == null ? null : json["number_of_visits"],
      minThreshold: json["min_threshold"] == null
          ? null
          : json["min_threshold"].toDouble(),
      increasePercentage: json["increase_percentage"] == null
          ? null
          : json["increase_percentage"],
      priceFactor: json["price_factor"] == null ? null : json["price_factor"],
      automaticActivation: json["automatic_activation"] == null
          ? null
          : json["automatic_activation"],
      underCheckAvailability: json["under_check_availability"] == null
          ? null
          : json["under_check_availability"],
      images: json["images"] == null
          ? new List<ProductImage>()
          : List<ProductImage>.from(
              json["images"].map((x) => ProductImage.fromJson(x))),
      categories: json["categories"] == null
          ? new List<CategoryOriginalData>()
          : List<CategoryOriginalData>.from(
              json["categories"].map((x) => CategoryOriginalData.fromJson(x))),
      warehouses: json["warehouses"] == null
          ? new List<Warehouse>()
          : List<Warehouse>.from(
              json["warehouses"].map((x) => Warehouse.fromJson(x))),
    );
    return productData;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "price": price,
        "is_active": isActive,
        "quantity": quantity,
        "productCount": productCount,
        "sub_warehouse_id": subWarehouseId,
        "supplier_code": supplierCode,
        "price_change": priceChange,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

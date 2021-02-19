// To parse this JSON data, do
//
//     final productsToReview = productsToReviewFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/models/productsCategoriesModel.dart';

ProductsToReview productsToReviewFromJson(String str) =>
    ProductsToReview.fromJson(json.decode(str));

String productsToReviewToJson(ProductsToReview data) =>
    json.encode(data.toJson());

class ProductsToReview {
  ProductsToReview({
    this.success,
    this.productsToActivate,
    this.productsToDeactivate,
  });

  bool success;
  List<ProductData> productsToActivate;
  List<ProductData> productsToDeactivate;

  factory ProductsToReview.fromJson(Map<String, dynamic> json) =>
      ProductsToReview(
        success: json["success"] == null ? null : json["success"],
        productsToActivate: json["products_to_activate"] == null
            ? null
            : List<ProductData>.from(json["products_to_activate"]
                .map((x) => ProductData.fromJson(x))),
        productsToDeactivate: json["products_to_deactivate"] == null
            ? null
            : List<ProductData>.from(json["products_to_deactivate"]
                .map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "products_to_activate": productsToActivate == null
            ? null
            : List<dynamic>.from(productsToActivate.map((x) => x.toJson())),
        "products_to_deactivate": productsToDeactivate == null
            ? null
            : List<dynamic>.from(productsToDeactivate.map((x) => x.toJson())),
      };
}

// class ProductsToActivate {
//   ProductsToActivate({
//     this.id,
//     this.name,
//     this.description,
//     this.unit,
//     this.productId,
//     this.warehouseId,
//     this.price,
//     this.isActive,
//     this.isFeatured,
//     this.priority,
//     this.numberOfVisits,
//     this.supplierCode,
//     this.minThreshold,
//     this.increasePercentage,
//     this.priceFactor,
//     this.underCheckAvailability,
//   });

//   int id;
//   String name;
//   String description;
//   String unit;
//   int productId;
//   int warehouseId;
//   String price;
//   int isActive;
//   int isFeatured;
//   int priority;
//   int numberOfVisits;
//   String supplierCode;
//   int minThreshold;
//   String increasePercentage;
//   String priceFactor;
//   int underCheckAvailability;

//   factory ProductsToActivate.fromJson(Map<String, dynamic> json) =>
//       ProductsToActivate(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         description: json["description"] == null ? null : json["description"],
//         unit: json["unit"] == null ? null : json["unit"],
//         productId: json["product_id"] == null ? null : json["product_id"],
//         warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
//         price: json["price"] == null ? null : json["price"],
//         isActive: json["is_active"] == null ? null : json["is_active"],
//         isFeatured: json["is_featured"] == null ? null : json["is_featured"],
//         priority: json["priority"] == null ? null : json["priority"],
//         numberOfVisits:
//             json["number_of_visits"] == null ? null : json["number_of_visits"],
//         supplierCode:
//             json["supplier_code"] == null ? null : json["supplier_code"],
//         minThreshold:
//             json["min_threshold"] == null ? null : json["min_threshold"],
//         increasePercentage: json["increase_percentage"] == null
//             ? null
//             : json["increase_percentage"],
//         priceFactor: json["price_factor"] == null ? null : json["price_factor"],
//         underCheckAvailability: json["under_check_availability"] == null
//             ? null
//             : json["under_check_availability"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "description": description == null ? null : description,
//         "unit": unit == null ? null : unit,
//         "product_id": productId == null ? null : productId,
//         "warehouse_id": warehouseId == null ? null : warehouseId,
//         "price": price == null ? null : price,
//         "is_active": isActive == null ? null : isActive,
//         "is_featured": isFeatured == null ? null : isFeatured,
//         "priority": priority == null ? null : priority,
//         "number_of_visits": numberOfVisits == null ? null : numberOfVisits,
//         "supplier_code": supplierCode == null ? null : supplierCode,
//         "min_threshold": minThreshold == null ? null : minThreshold,
//         "increase_percentage":
//             increasePercentage == null ? null : increasePercentage,
//         "price_factor": priceFactor == null ? null : priceFactor,
//         "under_check_availability":
//             underCheckAvailability == null ? null : underCheckAvailability,
//       };
// }

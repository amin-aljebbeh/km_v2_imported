// To parse this JSON data, do
//
//     final productsToReview = productsToReviewFromJson(jsonString);

import 'package:kammun_app/core/models/models_importer.dart';

ProductsToReview productsToReviewFromJson(String str) => ProductsToReview.fromJson(json.decode(str));

String productsToReviewToJson(ProductsToReview data) => json.encode(data.toJson());

class ProductsToReview {
  ProductsToReview({this.success, this.productsToActivate, this.productsToDeactivate});

  bool success;
  List<ProductData> productsToActivate;
  List<ProductData> productsToDeactivate;

  factory ProductsToReview.fromJson(Map<String, dynamic> json) => ProductsToReview(
        success: json['success'],
        productsToActivate: json['products_to_activate'] == null
            ? null
            : List<ProductData>.from(json['products_to_activate'].map((x) => ProductData.fromJson(x))),
        productsToDeactivate: json['products_to_deactivate'] == null
            ? null
            : List<ProductData>.from(json['products_to_deactivate'].map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'products_to_activate':
            productsToActivate == null ? null : List<dynamic>.from(productsToActivate.map((x) => x.toJson())),
        'products_to_deactivate':
            productsToDeactivate == null ? null : List<dynamic>.from(productsToDeactivate.map((x) => x.toJson())),
      };
}

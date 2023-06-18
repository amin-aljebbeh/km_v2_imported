// To parse this JSON data, do
//
//     final productsToReview = productsToReviewFromJson(jsonString);

import 'package:kammun_app/core/models/models_importer.dart';

import '../../../products/data/models/product_model.dart';

ProductsToReview productsToReviewFromJson(String str) => ProductsToReview.fromJson(json.decode(str));

class ProductsToReview {
  ProductsToReview({this.success, this.productsToActivate, this.productsToDeactivate});

  bool success;
  List<ProductModel> productsToActivate;
  List<ProductModel> productsToDeactivate;

  factory ProductsToReview.fromJson(Map<String, dynamic> json) => ProductsToReview(
        success: json['success'],
        productsToActivate: json['products_to_activate'] == null
            ? null
            : List<ProductModel>.from(json['products_to_activate'].map((x) => ProductModel.fromJson(x))),
        productsToDeactivate: json['products_to_deactivate'] == null
            ? null
            : List<ProductModel>.from(json['products_to_deactivate'].map((x) => ProductModel.fromJson(x))),
      );
}

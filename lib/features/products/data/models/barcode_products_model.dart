// To parse this JSON data, do
//
//     final barcodeProductsModel = barcodeProductsModelFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/features/products/data/models/product_model.dart';

BarcodeProductsModel barcodeProductsModelFromJson(String str) => BarcodeProductsModel.fromJson(json.decode(str));

class BarcodeProductsModel {
  bool success;
  List<ProductModel> products;

  BarcodeProductsModel({this.success, this.products});

  factory BarcodeProductsModel.fromJson(Map<String, dynamic> json) => BarcodeProductsModel(
        success: json['success'],
        products: List<ProductModel>.from(json['data'].map((x) => ProductModel.fromJson(x))),
      );
}

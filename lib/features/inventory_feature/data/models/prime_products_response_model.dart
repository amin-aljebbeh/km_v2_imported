import 'dart:convert';

import '../../../products_filter/data/models/products_pagination_model.dart';

PrimeProductsResponseModel primeProductsResponseModelFromJson(String str) =>
    PrimeProductsResponseModel.fromJson(json.decode(str));

class PrimeProductsResponseModel {
  PrimeProductsResponseModel({this.success, this.data});

  bool success;
  Data data;

  factory PrimeProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      PrimeProductsResponseModel(success: json["success"], data: Data.fromJson(json["data"]));
}

class Data {
  Data({this.primeProducts});

  ProductsPageModel primeProducts;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(primeProducts: ProductsPageModel.fromJson(json["prime_products"]));
}

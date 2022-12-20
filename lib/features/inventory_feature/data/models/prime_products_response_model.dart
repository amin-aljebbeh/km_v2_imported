import 'dart:convert';

import '../../../inventory/model/inventory_model_importer.dart';

PrimeProductsResponseModel primeProductsResponseModelFromJson(String str) =>
    PrimeProductsResponseModel.fromJson(json.decode(str));

String primeProductsResponseModelToJson(PrimeProductsResponseModel data) => json.encode(data.toJson());

class PrimeProductsResponseModel {
  PrimeProductsResponseModel({this.success, this.data});

  bool success;
  Data data;

  factory PrimeProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      PrimeProductsResponseModel(success: json["success"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  Data({this.primeProducts});

  FilterPagination primeProducts;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(primeProducts: FilterPagination.fromJson(json["prime_products"]));

  Map<String, dynamic> toJson() => {"prime_products": primeProducts.toJson()};
}

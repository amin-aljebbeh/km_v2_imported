// To parse this JSON data, do
//
//     final importedProducts = importedProductsFromJson(jsonString);

import 'dart:convert';

import 'package:kammun_app/models/models_importer.dart';

import 'report_model_importer.dart';

ImportedProducts importedProductsFromJson(String str) => ImportedProducts.fromJson(json.decode(str));

String importedProductsToJson(ImportedProducts data) => json.encode(data.toJson());

class ImportedProducts {
  ImportedProducts({
    this.productsPriceChange,
    this.nonIntroducedProducts,
    this.activatedList,
    this.toActiveList,
    this.toDeActiveList,
  });
  List<ProductData> toActiveList;
  List<ProductData> activatedList;
  List<ProductData> toDeActiveList;
  List<ProductData> productsPriceChange;
  List<NonIntroducedProduct> nonIntroducedProducts;

  factory ImportedProducts.fromJson(Map<String, dynamic> json) => ImportedProducts(
        toActiveList: json["toActiveList"] == null
            ? null
            : List<ProductData>.from(json["toActiveList"].map((x) => ProductData.fromJson(x))),
        activatedList: json["activatedList"] == null
            ? null
            : List<ProductData>.from(json["activatedList"].map((x) => ProductData.fromJson(x))),
        toDeActiveList: json["toDeactiveList"] == null
            ? null
            : List<ProductData>.from(json["toDeactiveList"].map((x) => ProductData.fromJson(x))),
        productsPriceChange: json["products_price_change"] == null
            ? null
            : List<ProductData>.from(json["products_price_change"].map((x) => ProductData.fromJson(x))),
        nonIntroducedProducts: json["nonIntroducedProducts"] == null
            ? null
            : List<NonIntroducedProduct>.from(
                json["nonIntroducedProducts"].map((x) => NonIntroducedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products_price_change":
            productsPriceChange == null ? null : List<dynamic>.from(productsPriceChange.map((x) => x.toJson())),
        "nonIntroducedProducts": nonIntroducedProducts == null
            ? null
            : List<dynamic>.from(nonIntroducedProducts.map((x) => x.toJson())),
      };
}

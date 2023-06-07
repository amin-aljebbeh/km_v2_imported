// To parse this JSON data, do
//
//     final importedProducts = importedProductsFromJson(jsonString);

import 'package:kammun_app/core/models/models_importer.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

InventoryFileProductModel inventoryFileProductModelProductsFromJson(String str) =>
    InventoryFileProductModel.fromJson(json.decode(str));

class InventoryFileProductModel {
  InventoryFileProductModel({this.nonIntroducedProducts, this.activatedList, this.toActiveList, this.toDeActiveList});
  List<ProductModel> toActiveList;
  List<ProductModel> activatedList;
  List<ProductModel> toDeActiveList;
  List<ProductModel> nonIntroducedProducts;

  factory InventoryFileProductModel.fromJson(Map<String, dynamic> json) => InventoryFileProductModel(
        toActiveList: json["toActiveList"] == null
            ? null
            : List<ProductModel>.from(json["toActiveList"].map((x) => ProductModel.fromJson(x))),
        activatedList: json["activatedList"] == null
            ? null
            : List<ProductModel>.from(json["activatedList"].map((x) => ProductModel.fromJson(x))),
        toDeActiveList: json["toDeactiveList"] == null
            ? null
            : List<ProductModel>.from(json["toDeactiveList"].map((x) => ProductModel.fromJson(x))),
        nonIntroducedProducts: json["nonIntroducedProducts"] == null
            ? null
            : List<ProductModel>.from(json["nonIntroducedProducts"].map((x) => ProductModel.fromJson(x))),
      );
}

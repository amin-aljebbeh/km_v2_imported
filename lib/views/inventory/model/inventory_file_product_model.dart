// To parse this JSON data, do
//
//     final importedProducts = importedProductsFromJson(jsonString);

import 'package:kammun_app/models/models_importer.dart';

InventoryFileProductModel inventoryFileProductModelProductsFromJson(String str) =>
    InventoryFileProductModel.fromJson(json.decode(str));

class InventoryFileProductModel {
  InventoryFileProductModel({this.nonIntroducedProducts, this.activatedList, this.toActiveList, this.toDeActiveList});
  List<ProductData> toActiveList;
  List<ProductData> activatedList;
  List<ProductData> toDeActiveList;
  List<ProductData> nonIntroducedProducts;

  factory InventoryFileProductModel.fromJson(Map<String, dynamic> json) => InventoryFileProductModel(
        toActiveList: json["toActiveList"] == null
            ? null
            : List<ProductData>.from(json["toActiveList"].map((x) => ProductData.fromJson(x))),
        activatedList: json["activatedList"] == null
            ? null
            : List<ProductData>.from(json["activatedList"].map((x) => ProductData.fromJson(x))),
        toDeActiveList: json["toDeactiveList"] == null
            ? null
            : List<ProductData>.from(json["toDeactiveList"].map((x) => ProductData.fromJson(x))),
        nonIntroducedProducts: json["nonIntroducedProducts"] == null
            ? null
            : List<ProductData>.from(json["nonIntroducedProducts"].map((x) => ProductData.fromJson(x))),
      );
}

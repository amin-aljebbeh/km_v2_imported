// To parse this JSON data, do
//
//     final importedProducts = importedProductsFromJson(jsonString);

import 'package:kammun_app/core/models/models_importer.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../domain/entities/inventory_file_product_entity.dart';

InventoryFileProductModel inventoryFileProductModelProductsFromJson(String str) =>
    InventoryFileProductModel.fromJson(json.decode(str));

class InventoryFileProductModel extends InventoryFileProductEntity {
  InventoryFileProductModel({nonIntroducedProducts, activatedList, toActiveList, toDeActiveList})
      : super(
          activatedList: activatedList,
          nonIntroducedProducts: nonIntroducedProducts,
          toActiveList: toActiveList,
          toDeActiveList: toDeActiveList,
        );

  factory InventoryFileProductModel.fromJson(Map<String, dynamic> json) => InventoryFileProductModel(
        toActiveList: json['toActiveList'] == null
            ? []
            : List<ProductModel>.from(json['toActiveList'].map((x) => ProductModel.fromJson(x))),
        activatedList: json['activatedList'] == null
            ? []
            : List<ProductModel>.from(json['activatedList'].map((x) => ProductModel.fromJson(x))),
        toDeActiveList: json['toDeactiveList'] == null
            ? []
            : List<ProductModel>.from(json['toDeactiveList'].map((x) => ProductModel.fromJson(x))),
        nonIntroducedProducts: json['nonIntroducedProducts'] == null
            ? []
            : List<ProductModel>.from(json['nonIntroducedProducts'].map((x) => ProductModel.fromJson(x))),
      );
}

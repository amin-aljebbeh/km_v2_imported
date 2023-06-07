import 'package:kammun_app/core/models/models_importer.dart';

import '../../products/data/models/product_model.dart';

PriceFileProductModel priceFileProductModelFromJson(String str) => PriceFileProductModel.fromJson(json.decode(str));

class PriceFileProductModel {
  PriceFileProductModel({this.productsPriceChange, this.nonIntroducedProducts});

  List<ProductModel> productsPriceChange;
  List<ProductModel> nonIntroducedProducts;

  factory PriceFileProductModel.fromJson(Map<String, dynamic> json) => PriceFileProductModel(
        productsPriceChange: json["products_price_change"] == null
            ? null
            : List<ProductModel>.from(json["products_price_change"].map((x) => ProductModel.fromJson(x))),
        nonIntroducedProducts: json["nonIntroducedProducts"] == null
            ? null
            : List<ProductModel>.from(json["nonIntroducedProducts"].map((x) => ProductModel.fromJson(x))),
      );
}

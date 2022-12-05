import 'package:kammun_app/core/models/models_importer.dart';

PriceFileProductModel priceFileProductModelFromJson(String str) => PriceFileProductModel.fromJson(json.decode(str));

String priceFileProductModelToJson(PriceFileProductModel data) => json.encode(data.toJson());

class PriceFileProductModel {
  PriceFileProductModel({this.productsPriceChange, this.nonIntroducedProducts});

  List<ProductData> productsPriceChange;
  List<ProductData> nonIntroducedProducts;

  factory PriceFileProductModel.fromJson(Map<String, dynamic> json) => PriceFileProductModel(
        productsPriceChange: json["products_price_change"] == null
            ? null
            : List<ProductData>.from(json["products_price_change"].map((x) => ProductData.fromJson(x))),
        nonIntroducedProducts: json["nonIntroducedProducts"] == null
            ? null
            : List<ProductData>.from(json["nonIntroducedProducts"].map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products_price_change":
            productsPriceChange == null ? null : List<dynamic>.from(productsPriceChange.map((x) => x.toJson())),
        "nonIntroducedProducts":
            nonIntroducedProducts == null ? null : List<dynamic>.from(nonIntroducedProducts.map((x) => x.toJson())),
      };
}

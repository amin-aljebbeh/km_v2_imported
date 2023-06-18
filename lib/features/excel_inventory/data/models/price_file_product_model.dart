import 'package:kammun_app/core/models/models_importer.dart';
import 'package:kammun_app/features/excel_inventory/domain/entities/price_file_product_entity.dart';

import '../../../products/data/models/product_model.dart';

PriceFileProductModel priceFileProductModelFromJson(String str) => PriceFileProductModel.fromJson(json.decode(str));

class PriceFileProductModel extends PriceFileProductEntity {
  PriceFileProductModel({productsPriceChange, nonIntroducedProducts})
      : super(nonIntroducedProducts: nonIntroducedProducts, productsPriceChange: productsPriceChange);

  factory PriceFileProductModel.fromJson(Map<String, dynamic> json) => PriceFileProductModel(
        productsPriceChange: json['products_price_change'] == null
            ? []
            : List<ProductModel>.from(json['products_price_change'].map((x) => ProductModel.fromJson(x))),
        nonIntroducedProducts: json['nonIntroducedProducts'] == null
            ? []
            : List<ProductModel>.from(json['nonIntroducedProducts'].map((x) => ProductModel.fromJson(x))),
      );
}

import 'package:kammun_app/features/inventory_feature/domain/entities/prices_changes_entity.dart';

import '../../../products/data/models/product_model.dart';

class PricesChangesModel extends PricesChangesEntity {
  PricesChangesModel({success, count, products}) : super(products: products, success: success, count: count);

  factory PricesChangesModel.fromJson(Map<String, dynamic> json) => PricesChangesModel(
        success: json['success'],
        count: json['count'],
        products: List<ProductModel>.from(json['proucts_price_change'].map((x) => ProductModel.fromJson(x))),
      );
}

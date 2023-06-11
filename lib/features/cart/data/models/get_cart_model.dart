import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';

ProductsResponse getProductsFromJson(String str) => ProductsResponse.fromJson(json.decode(str));

class ProductsResponse {
  bool success;
  List<ProductModel> products;

  ProductsResponse({this.success, this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
        success: json['success'],
        products: List<ProductModel>.from(json['data'].map((x) => ProductModel.fromJson(x))),
      );
}

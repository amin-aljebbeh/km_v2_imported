import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';

GetCart getCartFromJson(String str) => GetCart.fromJson(json.decode(str));

class GetCart {
  bool success;
  List<ProductModel> products;

  GetCart({this.success, this.products});

  factory GetCart.fromJson(Map<String, dynamic> json) => GetCart(
        success: json['success'],
        products: List<ProductModel>.from(json['data'].map((x) => ProductModel.fromJson(x))),
      );
}

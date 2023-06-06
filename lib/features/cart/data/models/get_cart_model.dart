import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';

List<ProductModel> getCartFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

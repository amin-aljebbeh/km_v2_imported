import 'package:kammun_app/core/models/models_importer.dart';

import '../../features/products/data/models/product_model.dart';
import '../core_importer.dart';


List<ProductModel> syncCartFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));


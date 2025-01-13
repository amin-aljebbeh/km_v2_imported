import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

class SpecialProductsModel {
  final String title;
  final String url;
  final List<ProductModel> products;
  final String totalNumber;
  final int nonActiveNumber;
  final bool hasNext;
  final ProductsViewTypes productsViewTypes;

  SpecialProductsModel({
    this.totalNumber,
    this.products,
    this.title,
    this.url,
    this.hasNext,
    this.nonActiveNumber,
    this.productsViewTypes,
  });
}

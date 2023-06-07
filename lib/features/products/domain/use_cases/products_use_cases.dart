import 'package:kammun_app/features/products/domain/use_cases/search_products_use_case.dart';

import '../../../../core/core_importer.dart';
import 'get_barcode_products_use_case.dart';
import 'get_category_products_use_case.dart';

class ProductsUSeCases {
  final GetBarcodeProductsUseCase getBarcodeProductsUseCase;
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  ProductsUSeCases({
    @required this.getBarcodeProductsUseCase,
    @required this.getCategoryProductsUseCase,
    @required this.searchProductsUseCase,
  }) : assert(getBarcodeProductsUseCase != null && getCategoryProductsUseCase != null && searchProductsUseCase != null,
            'All use cases should be initialized.');
}

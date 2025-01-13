import 'package:kammun_app/features/products/domain/use_cases/search_products_use_case.dart';

import '../../../../core/core_importer.dart';
import 'get_barcode_products_use_case.dart';
import 'get_category_products_use_case.dart';
import 'get_featured_products_use_case.dart';
import 'get_newly_added_products_use_case.dart';

class ProductsUSeCases {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetNewlyAddedProductsUseCase getNewlyAddedProductsUseCase;
  final GetBarcodeProductsUseCase getBarcodeProductsUseCase;
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  ProductsUSeCases({
    @required this.getFeaturedProductsUseCase,
    @required this.getNewlyAddedProductsUseCase,
    @required this.getBarcodeProductsUseCase,
    @required this.getCategoryProductsUseCase,
    @required this.searchProductsUseCase,
  }) : assert(
            getBarcodeProductsUseCase != null &&
                getCategoryProductsUseCase != null &&
                searchProductsUseCase != null &&
                getFeaturedProductsUseCase != null &&
                getNewlyAddedProductsUseCase != null,
            'All use cases should be initialized.');
}

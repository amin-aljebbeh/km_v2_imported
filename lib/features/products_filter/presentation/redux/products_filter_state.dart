import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/use_cases/products_filter_use_cases.dart';

@immutable
class ProductsFilterState extends Equatable {
  final ProductsFilterUseCases productsUSeCases;
  final List<ProductEntity> filteredProducts;
  final int filteredProductsPage;
  final bool hasNextFilteredProducts;
  final FilteredProductsTypes filteredProductsTypes;
  final String productsFilterSearchString;

  const ProductsFilterState({
    this.filteredProductsTypes,
    this.productsFilterSearchString,
    this.productsUSeCases,
    this.filteredProducts,
    this.filteredProductsPage,
    this.hasNextFilteredProducts,
  });

  factory ProductsFilterState.initial() {
    return ProductsFilterState(
      hasNextFilteredProducts: false,
      filteredProducts: const [],
      productsFilterSearchString: 'null',
      filteredProductsPage: 1,
      productsUSeCases: sl<ProductsFilterUseCases>(),
    );
  }

  ProductsFilterState copyWith({
    List<ProductEntity> filteredProducts,
    int filteredProductsPage,
    bool hasNextFilteredProducts,
    FilteredProductsTypes filteredProductsTypes,
    String productsFilterSearchString,
  }) {
    return ProductsFilterState(
      filteredProductsPage: filteredProductsPage ?? this.filteredProductsPage,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      productsUSeCases: productsUSeCases,
      filteredProductsTypes: filteredProductsTypes ?? this.filteredProductsTypes,
      hasNextFilteredProducts: hasNextFilteredProducts ?? this.hasNextFilteredProducts,
      productsFilterSearchString: productsFilterSearchString ?? this.productsFilterSearchString,
    );
  }

  @override
  List<Object> get props => [
        filteredProducts,
        filteredProductsPage,
        hasNextFilteredProducts,
        filteredProductsTypes,
        productsFilterSearchString,
        productsUSeCases,
      ];
}

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
  final bool biggerThan;
  final int number;
  final int total;
  final String fromDate;
  final String toDate;

  const ProductsFilterState({
    this.biggerThan,
    this.number,
    this.fromDate,
    this.total,
    this.toDate,
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
      productsFilterSearchString: '',
      filteredProductsPage: 1,
      biggerThan: true,
      total: 0,
      productsUSeCases: sl<ProductsFilterUseCases>(),
    );
  }

  ProductsFilterState copyWith({
    List<ProductEntity> filteredProducts,
    int filteredProductsPage,
    bool hasNextFilteredProducts,
    FilteredProductsTypes filteredProductsTypes,
    String productsFilterSearchString,
    int total,
    bool biggerThan,
    int number,
    String fromDate,
    String toDate,
  }) {
    return ProductsFilterState(
      filteredProductsPage: filteredProductsPage ?? this.filteredProductsPage,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      productsUSeCases: productsUSeCases,
      filteredProductsTypes: filteredProductsTypes ?? this.filteredProductsTypes,
      hasNextFilteredProducts: hasNextFilteredProducts ?? this.hasNextFilteredProducts,
      productsFilterSearchString: productsFilterSearchString ?? this.productsFilterSearchString,
      biggerThan: biggerThan ?? this.biggerThan,
      number: number ?? this.number,
      fromDate: fromDate ?? this.fromDate,
      total: total ?? this.total,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object> get props => [
        filteredProducts,
        total,
        filteredProductsPage,
        hasNextFilteredProducts,
        filteredProductsTypes,
        productsFilterSearchString,
        productsUSeCases,
        biggerThan,
        number,
        fromDate,
        toDate,
      ];
}

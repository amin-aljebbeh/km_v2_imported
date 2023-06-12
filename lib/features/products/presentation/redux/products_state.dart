import '../../../../core/core_importer.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/use_cases/products_use_cases.dart';

@immutable
class ProductsState extends Equatable {
  final ProductsUSeCases productsUSeCases;
  final List<ProductEntity> products;
  final int productsPage;
  final bool hasNextProducts;
  final bool badWordMatched;
  final ProductsViewTypes productsViewType;
  final int categoryId;
  final String searchString;

  const ProductsState({
    this.categoryId,
    this.searchString,
    this.productsUSeCases,
    this.products,
    this.productsPage,
    this.hasNextProducts,
    this.badWordMatched,
    this.productsViewType,
  });

  factory ProductsState.initial() {
    return ProductsState(
      badWordMatched: false,
      hasNextProducts: false,
      products: const [],
      categoryId: -1,
      searchString: 'null',
      productsPage: 1,
      productsUSeCases: sl<ProductsUSeCases>(),
    );
  }

  ProductsState copyWith({
    List<ProductEntity> products,
    int productsPage,
    bool hasNextProducts,
    bool badWordMatched,
    ProductsViewTypes productsViewType,
    int categoryId,
    String searchString,
  }) {
    return ProductsState(
      productsPage: productsPage ?? this.productsPage,
      products: products ?? this.products,
      productsUSeCases: productsUSeCases,
      productsViewType: productsViewType ?? this.productsViewType,
      hasNextProducts: hasNextProducts ?? this.hasNextProducts,
      badWordMatched: badWordMatched ?? this.badWordMatched,
      categoryId: categoryId ?? this.categoryId,
      searchString: searchString ?? this.searchString,
    );
  }

  @override
  List<Object> get props => [
        products,
        productsPage,
        hasNextProducts,
        badWordMatched,
        productsViewType,
        categoryId,
        searchString,
      ];
}

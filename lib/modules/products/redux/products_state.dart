import '../../../core/core_importer.dart';

@immutable
class ProductsState {
  final List<ProductData> products;
  final List<int> favorites;
  final bool hasNext;
  final ProductsViewTypes productsType;
  final int pageNumber;
  final bool emptyList;

  const ProductsState(
      {this.favorites, this.emptyList, this.products, this.pageNumber, this.productsType, this.hasNext});

  factory ProductsState.initial() {
    return const ProductsState(
      hasNext: true,
      productsType: null,
      pageNumber: 0,
      products: [],
      emptyList: false,
      favorites: [],
    );
  }

  ProductsState copyWith({
    bool hasNext,
    ProductsViewTypes productsType,
    int pageNumber,
    List<ProductData> products,
    bool emptyList,
    List<int> favorites,
  }) {
    return ProductsState(
      hasNext: hasNext ?? this.hasNext,
      productsType: productsType ?? this.productsType,
      products: products ?? this.products,
      pageNumber: pageNumber ?? this.pageNumber,
      emptyList: emptyList ?? this.emptyList,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsState &&
          runtimeType == other.runtimeType &&
          hasNext == other.hasNext &&
          productsType == other.productsType &&
          pageNumber == other.pageNumber &&
          products == other.products &&
          emptyList == other.emptyList &&
          favorites == other.favorites;

  @override
  int get hashCode => super.hashCode;
}

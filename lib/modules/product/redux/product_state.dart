import '../../../core/core_importer.dart';

@immutable
class ProductState {
  final ProductData product;
  final int quantity;
  final int selectedImage;

  const ProductState({this.quantity, this.selectedImage, this.product});

  factory ProductState.initial() {
    return const ProductState(product: null, quantity: 0, selectedImage: 0);
  }

  ProductState copyWith({bool isFavorite, ProductData product, int quantity, int selectedImage}) {
    return ProductState(
      product: product ?? this.product,
      selectedImage: selectedImage ?? this.selectedImage,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductState &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          selectedImage == other.selectedImage &&
          quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}

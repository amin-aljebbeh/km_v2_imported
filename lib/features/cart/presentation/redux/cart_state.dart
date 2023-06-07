import 'package:kammun_app/features/cart/domain/use_cases/cart_use_cases.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

@immutable
class CartState extends Equatable {
  final CartUseCases cartUSeCases;
  final List<ProductEntity> cartProducts;
  final int orderUnderUpdateId;
  final int indexToEdit;
  final String userNote;
  final int orderUnderUpdateStatus;
  final bool refund;
  final List<int> notActiveProducts;
  final List<int> pricesChangesProducts;
  final int deliveryPrice;

  const CartState({
    this.notActiveProducts,
    this.pricesChangesProducts,
    this.cartUSeCases,
    this.cartProducts,
    this.deliveryPrice,
    this.orderUnderUpdateId,
    this.indexToEdit,
    this.userNote,
    this.orderUnderUpdateStatus,
    this.refund,
  });

  factory CartState.initial() {
    return CartState(
      cartUSeCases: sl<CartUseCases>(),
      cartProducts: const [],
      orderUnderUpdateId: 0,
      indexToEdit: -1,
      notActiveProducts: const [],
      pricesChangesProducts: const [],
      orderUnderUpdateStatus: 0,
      refund: false,
      deliveryPrice: 50,
    );
  }

  CartState copyWith({
    List<ProductEntity> cartProducts,
    int orderUnderUpdateId,
    int indexToEdit,
    String userNote,
    int orderUnderUpdateStatus,
    bool refund,
    int deliveryPrice,
    List<int> notActiveProducts,
    List<int> pricesChangesProducts,
  }) {
    return CartState(
      cartUSeCases: cartUSeCases,
      cartProducts: cartProducts ?? this.cartProducts,
      indexToEdit: indexToEdit ?? this.indexToEdit,
      refund: refund ?? this.refund,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      userNote: userNote ?? this.userNote,
      notActiveProducts: notActiveProducts ?? this.notActiveProducts,
      pricesChangesProducts: pricesChangesProducts ?? this.pricesChangesProducts,
      orderUnderUpdateStatus: orderUnderUpdateStatus ?? this.orderUnderUpdateStatus,
      orderUnderUpdateId: orderUnderUpdateId ?? this.orderUnderUpdateId,
    );
  }

  @override
  List<Object> get props => [
        cartUSeCases,
        cartProducts,
        orderUnderUpdateId,
        indexToEdit,
        deliveryPrice,
        userNote,
        orderUnderUpdateStatus,
        refund,
        pricesChangesProducts,
        notActiveProducts
      ];
}

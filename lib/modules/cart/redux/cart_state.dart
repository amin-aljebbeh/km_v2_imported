import 'package:meta/meta.dart';

import '../../../core/common_models/product_model.dart';

@immutable
class CartState {
  final List<ProductData> cartProducts;
  final int subtotal;
  final int updateOrderId;
  final bool showCancelCoupon;

  const CartState({this.showCancelCoupon, this.updateOrderId, this.subtotal, this.cartProducts});

  factory CartState.initial() =>
      const CartState(cartProducts: [], subtotal: 0, updateOrderId: -1, showCancelCoupon: false);

  CartState copyWith({List<ProductData> cartProducts, int subtotal, int updateOrderId, bool showCancelCoupon}) {
    return CartState(
      cartProducts: cartProducts ?? this.cartProducts,
      subtotal: subtotal ?? this.subtotal,
      updateOrderId: updateOrderId ?? this.updateOrderId,
      showCancelCoupon: showCancelCoupon ?? this.showCancelCoupon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartState &&
          runtimeType == other.runtimeType &&
          cartProducts == other.cartProducts &&
          subtotal == other.subtotal &&
          showCancelCoupon == other.showCancelCoupon &&
          updateOrderId == other.updateOrderId;

  @override
  int get hashCode => super.hashCode;
}

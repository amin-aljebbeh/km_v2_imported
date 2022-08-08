import '../../../core/core_importer.dart';
import 'cart_action.dart';
import 'cart_state.dart';

Reducer<CartState> cartReducer = combineReducers<CartState>([
  TypedReducer<CartState, SaveCart>(saveCart),
  TypedReducer<CartState, CartLoadedSuccessfully>(cartLoadedSuccessfully),
  TypedReducer<CartState, ClearCart>(clearCart),
  TypedReducer<CartState, CalculateSubTotal>(calculateSubTotal),
  TypedReducer<CartState, ShowCartCancelCoupon>(showCancelCoupon),
  TypedReducer<CartState, HideCartCancelCoupon>(hideCancelCoupon),
]);

CartState saveCart(CartState state, SaveCart action) {
  return state.copyWith(cartProducts: action.cartProducts);
}

CartState cartLoadedSuccessfully(CartState state, CartLoadedSuccessfully action) {
  return state.copyWith(cartProducts: action.cartProducts);
}

CartState clearCart(CartState state, ClearCart action) {
  return state.copyWith(cartProducts: []);
}

CartState showCancelCoupon(CartState state, ShowCartCancelCoupon action) {
  return state.copyWith(showCancelCoupon: true);
}

CartState hideCancelCoupon(CartState state, HideCartCancelCoupon action) {
  return state.copyWith(showCancelCoupon: false);
}

CartState calculateSubTotal(CartState state, CalculateSubTotal action) {
  int subtotal = 0;
  for (int i = 0; i < state.cartProducts.length; i++) {
    subtotal =
        subtotal + ((int.parse(state.cartProducts[i].price.split('.')[0])) * state.cartProducts[i].productCount);
  }
  return state.copyWith(subtotal: subtotal);
}

import '../../../../core/core_importer.dart';
import 'cart_action.dart';
import 'cart_state.dart';

Reducer<CartState> cartReducer = combineReducers<CartState>([
  TypedReducer<CartState, SetRefund>(setRefund),
  TypedReducer<CartState, SetOrderId>(setOrderId),
  TypedReducer<CartState, SetUserNote>(setUserNote),
  TypedReducer<CartState, SetEditIndex>(setEditIndex),
  TypedReducer<CartState, SetOrderStatus>(setOrderStatus),
  TypedReducer<CartState, SetOrderProblem>(setOrderProblem),
  TypedReducer<CartState, SetCartProducts>(setCartProducts),
  TypedReducer<CartState, SetDeliveryPrice>(setDeliveryPrice),
]);

CartState setOrderId(CartState state, SetOrderId action) {
  return state.copyWith(orderUnderUpdateId: action.orderId);
}

CartState setEditIndex(CartState state, SetEditIndex action) {
  return state.copyWith(indexToEdit: action.index);
}

CartState setCartProducts(CartState state, SetCartProducts action) {
  return state.copyWith(cartProducts: action.products);
}

CartState setUserNote(CartState state, SetUserNote action) {
  return state.copyWith(userNote: action.note);
}

CartState setOrderStatus(CartState state, SetOrderStatus action) {
  return state.copyWith(orderUnderUpdateStatus: action.statusId);
}

CartState setRefund(CartState state, SetRefund action) {
  return state.copyWith(refund: action.refund);
}

CartState setOrderProblem(CartState state, SetOrderProblem action) {
  return state.copyWith(
      notActiveProducts: action.notActiveProducts, pricesChangesProducts: action.pricesChangesProducts);
}

CartState setDeliveryPrice(CartState state, SetDeliveryPrice action) {
  return state.copyWith(deliveryPrice: action.deliveryPrice);
}

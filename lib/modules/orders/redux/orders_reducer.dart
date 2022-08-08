import 'package:kammun_app/core/core_importer.dart';

import 'orders_action.dart';
import 'orders_state.dart';

Reducer<OrdersState> ordersReducer = combineReducers<OrdersState>([
  TypedReducer<OrdersState, OrdersFetchedSuccessfully>(ordersFetchedSuccessfully),
  TypedReducer<OrdersState, SetUpdateOrderId>(setUpdateOrderId),
  TypedReducer<OrdersState, SetNote>(setNote),
]);

OrdersState ordersFetchedSuccessfully(OrdersState state, OrdersFetchedSuccessfully action) {
  return state.copyWith(orders: action.orders);
}

OrdersState setUpdateOrderId(OrdersState state, SetUpdateOrderId action) {
  return state.copyWith(updatedOrderId: action.orderId);
}

OrdersState setNote(OrdersState state, SetNote action) {
  return state.copyWith(updateNote: action.note);
}

import 'package:kammun_app/features/orders_feature/presentation/redux/orders_state.dart';

import '../../../../core/core_importer.dart';
import 'orders_action.dart';

Reducer<OrdersState> ordersReducer = combineReducers<OrdersState>([
  TypedReducer<OrdersState, SetViewOrders>(setViewOrders),
  TypedReducer<OrdersState, SetViewOrders>(setViewOrders),
]);

OrdersState setViewOrders(OrdersState state, SetViewOrders action) {
  return state.copyWith(viewOrders: action.orders);
}

OrdersState setSearchOrders(OrdersState state, SetSearchOrders action) {
  return state.copyWith(searchOrders: action.orders);
}

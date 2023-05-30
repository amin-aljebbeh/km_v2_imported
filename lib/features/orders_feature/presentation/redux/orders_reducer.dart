import 'package:kammun_app/features/orders_feature/presentation/redux/orders_state.dart';

import '../../../../core/core_importer.dart';
import 'orders_action.dart';

Reducer<OrdersState> ordersReducer = combineReducers<OrdersState>([
  TypedReducer<OrdersState, SetViewOrders>(setViewOrders),
  TypedReducer<OrdersState, SetOrdersStatusFilter>(setOrderStatusFilter),
  TypedReducer<OrdersState, SetLimitedOrdersPage>(setLimitedOrdersPage),
  TypedReducer<OrdersState, SetOrdersPage>(setOrdersPage),
  TypedReducer<OrdersState, SetAssignFilter>(setAssignFilter),
  TypedReducer<OrdersState, SetWarehouseFilter>(setWarehouseFilter),
  TypedReducer<OrdersState, SetRateFilter>(setRateFilter),
]);

OrdersState setViewOrders(OrdersState state, SetViewOrders action) {
  return state.copyWith(orders: action.orders);
}

OrdersState setOrderStatusFilter(OrdersState state, SetOrdersStatusFilter action) {
  return state.copyWith(statusFilter: action.filter);
}

OrdersState setLimitedOrdersPage(OrdersState state, SetLimitedOrdersPage action) {
  return state.copyWith(limitedOrdersPage: action.page);
}

OrdersState setOrdersPage(OrdersState state, SetOrdersPage action) {
  return state.copyWith(ordersPage: action.page);
}

OrdersState setAssignFilter(OrdersState state, SetAssignFilter action) {
  return state.copyWith(assignFilter: action.filter);
}

OrdersState setWarehouseFilter(OrdersState state, SetWarehouseFilter action) {
  return state.copyWith(warehouseFilter: action.filter);
}

OrdersState setRateFilter(OrdersState state, SetRateFilter action) {
  return state.copyWith(rateFilter: action.filter);
}

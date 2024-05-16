import 'package:kammun_app/features/orders/presentation/redux/orders_state.dart';

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
  TypedReducer<OrdersState, SetToDateFilter>(setToDate),
  TypedReducer<OrdersState, SetFromDateFilter>(setFromDate),
  TypedReducer<OrdersState, SetShopperFilter>(setShopperId),
  TypedReducer<OrdersState, SetSupportedCityFilter>(setSupportedCityId),
  TypedReducer<OrdersState, SetShopperNameFilter>(setShopperNameFilter),
  TypedReducer<OrdersState, SetTotalOrdersNumber>(seTotalOrdersNumber),
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

OrdersState setToDate(OrdersState state, SetToDateFilter action) {
  return state.copyWith(toDateFilter: action.toDateFilter);
}

OrdersState setFromDate(OrdersState state, SetFromDateFilter action) {
  return state.copyWith(fromDateFilter: action.fromDateFilter);
}

OrdersState setShopperId(OrdersState state, SetShopperFilter action) {
  return state.copyWith(shopperFilter: action.shopperFilter);
}

OrdersState setSupportedCityId(OrdersState state, SetSupportedCityFilter action) {
  return state.copyWith(supportedCityFilter: action.supportedCityFilter);
}

OrdersState setShopperNameFilter(OrdersState state, SetShopperNameFilter action) {
  return state.copyWith(shopperNameFilter: action.shopperNameFilter);
}

OrdersState seTotalOrdersNumber(OrdersState state, SetTotalOrdersNumber action) {
  return state.copyWith(totalOrdersNumber: action.totalNumber);
}

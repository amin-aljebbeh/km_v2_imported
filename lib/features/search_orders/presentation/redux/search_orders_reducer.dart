import '../../../../core/core_importer.dart';
import 'search_orders_action.dart';
import 'search_orders_state.dart';

Reducer<SearchOrdersState> searchOrdersReducer = combineReducers<SearchOrdersState>([
  TypedReducer<SearchOrdersState, SetSearchOrders>(setSearchOrders),
  TypedReducer<SearchOrdersState, SetSearchStatusFilter>(setSearchStatusFilter),
  TypedReducer<SearchOrdersState, SetSearchPage>(setSearchPage),
]);

SearchOrdersState setSearchOrders(SearchOrdersState state, SetSearchOrders action) {
  return state.copyWith(orders: action.orders);
}

SearchOrdersState setSearchStatusFilter(SearchOrdersState state, SetSearchStatusFilter action) {
  return state.copyWith(statusFilter: action.filter);
}

SearchOrdersState setSearchPage(SearchOrdersState state, SetSearchPage action) {
  return state.copyWith(page: action.page);
}

import '../../../../core/core_importer.dart';
import 'search_orders_action.dart';
import 'search_orders_state.dart';

Reducer<SearchOrdersState> searchOrdersReducer = combineReducers<SearchOrdersState>([
  TypedReducer<SearchOrdersState, SetSearchOrders>(setSearchOrders),
  TypedReducer<SearchOrdersState, SetSearchStatusFilter>(setSearchStatusFilter),
  TypedReducer<SearchOrdersState, SetSearchPage>(setSearchPage),
  TypedReducer<SearchOrdersState, SetSearchOrdersType>(setSearchOrdersType),
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

SearchOrdersState setSearchOrdersType(SearchOrdersState state, SetSearchOrdersType action) {
  return state.copyWith(searchOrdersType: action.searchOrdersType);
}

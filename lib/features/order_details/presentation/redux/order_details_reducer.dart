import 'package:kammun_app/features/order_details/presentation/redux/order_details_state.dart';

import '../../../../core/core_importer.dart';
import 'order_details_action.dart';

Reducer<OrderDetailsState> orderDetailsReducer = combineReducers<OrderDetailsState>([
  TypedReducer<OrderDetailsState, SetOrderInvoice>(setOrderInvoice),
  TypedReducer<OrderDetailsState, ShowSubWarehouseProducts>(showSubWarehouseProducts),
  TypedReducer<OrderDetailsState, SetAuthenticatedSubWarehouses>(setAuthenticatedSubWarehouses),
]);

OrderDetailsState setOrderInvoice(OrderDetailsState state, SetOrderInvoice action) {
  return state.copyWith(invoice: action.invoice);
}

OrderDetailsState setAuthenticatedSubWarehouses(OrderDetailsState state, SetAuthenticatedSubWarehouses action) {
  return state.copyWith(authenticatedSubWarehouses: action.authenticatedSubWarehouses);
}

OrderDetailsState showSubWarehouseProducts(OrderDetailsState state, ShowSubWarehouseProducts action) {
  Map<int, List<int>> authenticatedSubWarehouses = {};
  authenticatedSubWarehouses.addAll(state.authenticatedSubWarehouses);
  authenticatedSubWarehouses[action.orderId].add(action.subWareHouseId);
  return state.copyWith(authenticatedSubWarehouses: authenticatedSubWarehouses);
}

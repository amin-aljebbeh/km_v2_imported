import 'package:kammun_app/features/order_details/presentation/redux/order_details_state.dart';

import '../../../../core/core_importer.dart';
import 'order_details_action.dart';

Reducer<OrderDetailsState> orderDetailsReducer = combineReducers<OrderDetailsState>([
  TypedReducer<OrderDetailsState, SetOrderInvoice>(setOrderInvoice),
]);

OrderDetailsState setOrderInvoice(OrderDetailsState state, SetOrderInvoice action) {
  return state.copyWith(invoice: action.invoice);
}

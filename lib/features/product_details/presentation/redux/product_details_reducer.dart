import 'package:kammun_app/features/product_details/presentation/redux/product_details_state.dart';

import '../../../../core/core_importer.dart';
// import 'product_details_action.dart';

Reducer<ProductDetailsState> productDetailsReducer = combineReducers<ProductDetailsState>([
  // TypedReducer<ProductDetailsState, SetViewOrders>(setViewOrders),
]);

// ProductDetailsState setViewOrders(ProductDetailsState state, SetViewOrders action) {
//   return state.copyWith(orders: action.orders);
// }

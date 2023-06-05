import 'package:kammun_app/features/admins/presentation/redux/admins_reducer.dart';
import 'package:kammun_app/features/error/presentation/redux/error_reducer.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_reducer.dart';
import 'package:kammun_app/features/loading/presentation/redux/loading_reducer.dart';
import 'package:kammun_app/features/order_details/presentation/redux/order_details_reducer.dart';
import 'package:kammun_app/features/orders/presentation/redux/orders_reducer.dart';
import 'package:kammun_app/features/supplier/presentation/redux/supplier_reducer.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_reducer.dart';
import 'package:kammun_app/features/users/presentation/redux/users_reducer.dart';

import '../core/core_importer.dart';
import '../features/complaints/presentation/redux/complaints_reducer.dart';
import '../features/coupons/presentation/redux/coupon_reducer.dart';
import '../features/search_orders/presentation/redux/search_orders_reducer.dart';
import '../features/shoppers/presentation/redux/shoppers_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is RestartApp) return AppState.initial();
  return AppState(
    inventoryState: inventoryReducer(state.inventoryState, action),
    loadingState: loadingReducer(state.loadingState, action),
    errorState: errorReducer(state.errorState, action),
    supplierState: supplierReducer(state.supplierState, action),
    complaintsState: complaintsReducer(state.complaintsState, action),
    adminsState: adminsReducer(state.adminsState, action),
    usersState: usersReducer(state.usersState, action),
    couponState: couponReducer(state.couponState, action),
    ordersState: ordersReducer(state.ordersState, action),
    transactionsState: transactionsReducer(state.transactionsState, action),
    shoppersState: shoppersReducer(state.shoppersState, action),
    searchOrdersState: searchOrdersReducer(state.searchOrdersState, action),
    orderDetailsState: orderDetailsReducer(state.orderDetailsState, action),
  );
}

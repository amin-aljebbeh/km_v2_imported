import 'package:kammun_app/features/loading/presentation/redux/loading_state.dart';
import 'package:kammun_app/features/orders/presentation/redux/orders_state.dart';
import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_state.dart';
import 'package:kammun_app/features/shoppers/presentation/redux/shoppers_state.dart';

import '../core/core_importer.dart';
import '../features/admins/presentation/redux/admins_state.dart';
import '../features/cart/presentation/redux/cart_state.dart';
import '../features/complaints/presentation/redux/complaints_state.dart';
import '../features/coupons/presentation/redux/coupon_state.dart';
import '../features/error/presentation/redux/error_state.dart';
import '../features/inventory_feature/presentation/redux/inventory_state.dart';
import '../features/order_details/presentation/redux/order_details_state.dart';
import '../features/supplier/presentation/redux/supplier_state.dart';
import '../features/transactions/presentation/redux/transactions_state.dart';
import '../features/users/presentation/redux/users_state.dart';

@immutable
class AppState extends Equatable {
  final AdminsState adminsState;
  final CartState cartState;
  final ComplaintsState complaintsState;
  final CouponState couponState;
  final ErrorState errorState;
  final InventoryState inventoryState;
  final LoadingState loadingState;
  final OrderDetailsState orderDetailsState;
  final OrdersState ordersState;
  final SearchOrdersState searchOrdersState;
  final ShoppersState shoppersState;
  final SupplierState supplierState;
  final TransactionsState transactionsState;
  final UsersState usersState;

  const AppState({
    this.ordersState,
    this.orderDetailsState,
    this.transactionsState,
    this.inventoryState,
    this.errorState,
    this.loadingState,
    this.searchOrdersState,
    this.supplierState,
    this.complaintsState,
    this.adminsState,
    this.couponState,
    this.usersState,
    this.shoppersState,
    this.cartState,
  });

  factory AppState.initial() => AppState(
        inventoryState: InventoryState.initial(),
        errorState: ErrorState.initial(),
        loadingState: LoadingState.initial(),
        supplierState: SupplierState.initial(),
        complaintsState: ComplaintsState.initial(),
        adminsState: AdminsState.initial(),
        couponState: CouponState.initial(),
        usersState: UsersState.initial(),
        searchOrdersState: SearchOrdersState.initial(),
        ordersState: OrdersState.initial(),
        transactionsState: TransactionsState.initial(),
        shoppersState: ShoppersState.initial(),
        orderDetailsState: OrderDetailsState.initial(),
        cartState: CartState.initial(),
      );

  AppState copyWith({
    InventoryState inventoryState,
    ErrorState errorState,
    LoadingState loadingState,
    SupplierState supplierState,
    ComplaintsState complaintsState,
    AdminsState adminsState,
    CouponState couponState,
    UsersState usersState,
    SearchOrdersState searchOrdersState,
    OrdersState ordersState,
    TransactionsState transactionsState,
    ShoppersState shoppersState,
    OrderDetailsState orderDetailsState,
    CartState cartState,
  }) {
    return AppState(
      inventoryState: inventoryState ?? this.inventoryState,
      errorState: errorState ?? this.errorState,
      loadingState: loadingState ?? this.loadingState,
      supplierState: supplierState ?? this.supplierState,
      complaintsState: complaintsState ?? this.complaintsState,
      adminsState: adminsState ?? this.adminsState,
      couponState: couponState ?? this.couponState,
      usersState: usersState ?? this.usersState,
      searchOrdersState: searchOrdersState ?? this.searchOrdersState,
      ordersState: ordersState ?? this.ordersState,
      transactionsState: transactionsState ?? this.transactionsState,
      shoppersState: shoppersState ?? this.shoppersState,
      orderDetailsState: orderDetailsState ?? this.orderDetailsState,
      cartState: cartState ?? this.cartState,
    );
  }

  @override
  List<Object> get props => [
        inventoryState,
        errorState,
        loadingState,
        supplierState,
        transactionsState,
        complaintsState,
        adminsState,
        searchOrdersState,
        couponState,
        usersState,
        ordersState,
        orderDetailsState,
        shoppersState,
        cartState,
      ];
}

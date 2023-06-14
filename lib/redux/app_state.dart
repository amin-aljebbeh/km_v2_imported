import 'package:kammun_app/features/barcode/presentation/redux/barcode_state.dart';
import 'package:kammun_app/features/loading/presentation/redux/loading_state.dart';
import 'package:kammun_app/features/orders/presentation/redux/orders_state.dart';
import 'package:kammun_app/features/product_details/presentation/redux/product_details_state.dart';
import 'package:kammun_app/features/products/presentation/redux/products_state.dart';
import 'package:kammun_app/features/products_filter/presentation/redux/products_filter_state.dart';
import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_state.dart';
import 'package:kammun_app/features/shoppers/presentation/redux/shoppers_state.dart';

import '../core/core_importer.dart';
import '../features/admins/presentation/redux/admins_state.dart';
import '../features/cart/presentation/redux/cart_state.dart';
import '../features/complaints/presentation/redux/complaints_state.dart';
import '../features/coupons/presentation/redux/coupon_state.dart';
import '../features/error/presentation/redux/error_state.dart';
import '../features/general_information/presentation/redux/general_information_state.dart';
import '../features/home/presentation/redux/home_state.dart';
import '../features/inventory_feature/presentation/redux/inventory_state.dart';
import '../features/order_details/presentation/redux/order_details_state.dart';
import '../features/supplier/presentation/redux/supplier_state.dart';
import '../features/transactions/presentation/redux/transactions_state.dart';
import '../features/users/presentation/redux/users_state.dart';

@immutable
class AppState extends Equatable {
  final AdminsState adminsState;
  final BarcodeState barcodeState;
  final CartState cartState;
  final ComplaintsState complaintsState;
  final CouponState couponState;
  final ErrorState errorState;
  final GeneralInformationState generalInformationState;
  final HomeState homeState;
  final InventoryState inventoryState;
  final LoadingState loadingState;
  final OrderDetailsState orderDetailsState;
  final OrdersState ordersState;
  final ProductDetailsState productDetailsState;
  final ProductsState productsState;
  final ProductsFilterState productsFilterState;
  final SearchOrdersState searchOrdersState;
  final ShoppersState shoppersState;
  final SupplierState supplierState;
  final TransactionsState transactionsState;
  final UsersState usersState;

  const AppState({
    this.ordersState,
    this.productsFilterState,
    this.generalInformationState,
    this.orderDetailsState,
    this.transactionsState,
    this.homeState,
    this.inventoryState,
    this.productDetailsState,
    this.productsState,
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
    this.barcodeState,
  });

  factory AppState.initial() => AppState(
        inventoryState: InventoryState.initial(),
        errorState: ErrorState.initial(),
        productsFilterState: ProductsFilterState.initial(),
        loadingState: LoadingState.initial(),
        supplierState: SupplierState.initial(),
        complaintsState: ComplaintsState.initial(),
        adminsState: AdminsState.initial(),
        generalInformationState: GeneralInformationState.initial(),
        homeState: HomeState.initial(),
        productDetailsState: ProductDetailsState.initial(),
        couponState: CouponState.initial(),
        usersState: UsersState.initial(),
        productsState: ProductsState.initial(),
        searchOrdersState: SearchOrdersState.initial(),
        ordersState: OrdersState.initial(),
        transactionsState: TransactionsState.initial(),
        shoppersState: ShoppersState.initial(),
        orderDetailsState: OrderDetailsState.initial(),
        cartState: CartState.initial(),
        barcodeState: BarcodeState.initial(),
      );

  AppState copyWith({
    InventoryState inventoryState,
    ErrorState errorState,
    LoadingState loadingState,
    ProductDetailsState productDetailsState,
    SupplierState supplierState,
    ComplaintsState complaintsState,
    AdminsState adminsState,
    CouponState couponState,
    ProductsState productsState,
    UsersState usersState,
    ProductsFilterState productsFilterState,
    GeneralInformationState generalInformationState,
    HomeState homeState,
    SearchOrdersState searchOrdersState,
    OrdersState ordersState,
    TransactionsState transactionsState,
    ShoppersState shoppersState,
    OrderDetailsState orderDetailsState,
    CartState cartState,
    BarcodeState barcodeState,
  }) {
    return AppState(
      inventoryState: inventoryState ?? this.inventoryState,
      barcodeState: barcodeState ?? this.barcodeState,
      productsFilterState: productsFilterState ?? this.productsFilterState,
      generalInformationState: generalInformationState ?? this.generalInformationState,
      errorState: errorState ?? this.errorState,
      loadingState: loadingState ?? this.loadingState,
      supplierState: supplierState ?? this.supplierState,
      complaintsState: complaintsState ?? this.complaintsState,
      adminsState: adminsState ?? this.adminsState,
      homeState: homeState ?? this.homeState,
      couponState: couponState ?? this.couponState,
      usersState: usersState ?? this.usersState,
      productsState: productsState ?? this.productsState,
      searchOrdersState: searchOrdersState ?? this.searchOrdersState,
      ordersState: ordersState ?? this.ordersState,
      transactionsState: transactionsState ?? this.transactionsState,
      shoppersState: shoppersState ?? this.shoppersState,
      orderDetailsState: orderDetailsState ?? this.orderDetailsState,
      cartState: cartState ?? this.cartState,
      productDetailsState: productDetailsState ?? this.productDetailsState,
    );
  }

  @override
  List<Object> get props => [
        inventoryState,
        errorState,
        loadingState,
        homeState,
        supplierState,
        transactionsState,
        complaintsState,
        barcodeState,
        adminsState,
        productsFilterState,
        productsState,
        searchOrdersState,
        generalInformationState,
        couponState,
        productDetailsState,
        usersState,
        ordersState,
        orderDetailsState,
        shoppersState,
        cartState,
      ];
}

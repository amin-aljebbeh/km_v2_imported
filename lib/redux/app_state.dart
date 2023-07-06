import 'package:kammun_app/features/authentication/presentation/redux/authentication_state.dart';

import '../core/core_importer.dart';
import '../features/admins/presentation/redux/admins_state.dart';
import '../features/barcode/presentation/redux/barcode_state.dart';
import '../features/cart/presentation/redux/cart_state.dart';
import '../features/complaints/presentation/redux/complaints_state.dart';
import '../features/coupons/presentation/redux/coupon_state.dart';
import '../features/error/presentation/redux/error_state.dart';
import '../features/general_information/presentation/redux/general_information_state.dart';
import '../features/home/presentation/redux/home_state.dart';
import '../features/inventory/presentation/redux/inventory_state.dart';
import '../features/loading/presentation/redux/loading_state.dart';
import '../features/order_details/presentation/redux/order_details_state.dart';
import '../features/orders/presentation/redux/orders_state.dart';
import '../features/product_details/presentation/redux/product_details_state.dart';
import '../features/products/presentation/redux/products_state.dart';
import '../features/products_filter/presentation/redux/products_filter_state.dart';
import '../features/reports/presentation/redux/reports_state.dart';
import '../features/search_orders/presentation/redux/search_orders_state.dart';
import '../features/shoppers/presentation/redux/shoppers_state.dart';
import '../features/shoppers_reports/presentation/redux/shoppers_reports_state.dart';
import '../features/sub_warehouse_manager/presentation/inventory_file_redux/inventory_file_state.dart';
import '../features/sub_warehouse_manager/presentation/price_file_redux/price_file_state.dart';
import '../features/sub_warehouse_manager/presentation/redux/sub_warehouse_manager_state.dart';
import '../features/supplier/presentation/redux/supplier_state.dart';
import '../features/transactions/presentation/redux/transactions_state.dart';
import '../features/users/presentation/redux/users_state.dart';

@immutable
class AppState extends Equatable {
  final AdminsState adminsState;
  final AuthenticationState authenticationState;
  final BarcodeState barcodeState;
  final CartState cartState;
  final ComplaintsState complaintsState;
  final CouponState couponState;
  final ErrorState errorState;
  final InventoryFileState inventoryFileState;
  final PriceFileState priceFileState;
  final SubWarehouseManagerState excelInventoryState;
  final GeneralInformationState generalInformationState;
  final HomeState homeState;
  final InventoryState inventoryState;
  final LoadingState loadingState;
  final OrderDetailsState orderDetailsState;
  final OrdersState ordersState;
  final ProductDetailsState productDetailsState;
  final ProductsState productsState;
  final ProductsFilterState productsFilterState;
  final ReportsState reportState;
  final SearchOrdersState searchOrdersState;
  final ShoppersState shoppersState;
  final ShoppersReportsState shoppersReportsState;
  final SupplierState supplierState;
  final TransactionsState transactionsState;
  final UsersState usersState;

  const AppState({
    this.excelInventoryState,
    this.reportState,
    this.shoppersReportsState,
    this.authenticationState,
    this.inventoryFileState,
    this.priceFileState,
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
        reportState: ReportsState.initial(),
        authenticationState: AuthenticationState.initial(),
        errorState: ErrorState.initial(),
        shoppersReportsState: ShoppersReportsState.initial(),
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
        inventoryFileState: InventoryFileState.initial(),
        priceFileState: PriceFileState.initial(),
        excelInventoryState: SubWarehouseManagerState.initial(),
        barcodeState: BarcodeState.initial(),
      );

  AppState copyWith({
    SubWarehouseManagerState excelInventoryState,
    AuthenticationState authenticationState,
    PriceFileState priceFileState,
    InventoryFileState inventoryFileState,
    InventoryState inventoryState,
    ErrorState errorState,
    ReportsState reportState,
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
    ShoppersReportsState shoppersReportsState,
    BarcodeState barcodeState,
  }) {
    return AppState(
      inventoryState: inventoryState ?? this.inventoryState,
      authenticationState: authenticationState ?? this.authenticationState,
      excelInventoryState: excelInventoryState ?? this.excelInventoryState,
      barcodeState: barcodeState ?? this.barcodeState,
      productsFilterState: productsFilterState ?? this.productsFilterState,
      generalInformationState: generalInformationState ?? this.generalInformationState,
      errorState: errorState ?? this.errorState,
      reportState: reportState ?? this.reportState,
      loadingState: loadingState ?? this.loadingState,
      inventoryFileState: inventoryFileState ?? this.inventoryFileState,
      supplierState: supplierState ?? this.supplierState,
      complaintsState: complaintsState ?? this.complaintsState,
      adminsState: adminsState ?? this.adminsState,
      homeState: homeState ?? this.homeState,
      priceFileState: priceFileState ?? this.priceFileState,
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
      shoppersReportsState: shoppersReportsState ?? this.shoppersReportsState,
    );
  }

  @override
  List<Object> get props => [
        inventoryState,
        errorState,
        loadingState,
        authenticationState,
        reportState,
        homeState,
        shoppersReportsState,
        supplierState,
        transactionsState,
        complaintsState,
        barcodeState,
        adminsState,
        productsFilterState,
        productsState,
        excelInventoryState,
        searchOrdersState,
        generalInformationState,
        couponState,
        productDetailsState,
        usersState,
        ordersState,
        orderDetailsState,
        shoppersState,
        cartState,
        priceFileState,
        inventoryFileState,
      ];
}

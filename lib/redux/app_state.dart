import 'package:flutter/material.dart';

import '../modules/address/redux/address_state.dart';
import '../modules/authentication/redux/authentication_state.dart';
import '../modules/cart/redux/cart_state.dart';
import '../modules/delivery_method/redux/delivery_method_state.dart';
import '../modules/error/redux/error_state.dart';
import '../modules/home_page/redux/home_page_state.dart';
import '../modules/invoice/redux/invoice_state.dart';
import '../modules/loading/redux/loading_state.dart';
import '../modules/map/redux/map_state.dart';
import '../modules/navigation/redux/navigation_state.dart';
import '../modules/order/redux/order_state.dart';
import '../modules/orders/redux/orders_state.dart';
import '../modules/payment/redux/payment_state.dart';
import '../modules/product/redux/product_state.dart';
import '../modules/products/redux/products_state.dart';
import '../modules/startup/redux/startup_state.dart';
import '../modules/supported_city/redux/supported_city_state.dart';
import '../modules/update/redux/update_state.dart';

@immutable
class AppState {
  final double restart;
  final AddressState addressState;
  final AuthenticationState authenticationState;
  final CartState cartState;
  final DeliveryMethodState deliveryMethodState;
  final ErrorState errorState;
  final HomePageState homePageState;
  final InvoiceState invoiceState;
  final LoadingState loadingState;
  final NavigationState navigationState;
  final OrderState orderState;
  final OrdersState ordersState;
  final ProductState productState;
  final ProductsState productsState;
  final StartupState startupState;
  final SupportedCityState supportedCityState;
  final UpdateState updateState;
  final MapState mapState;
  final PaymentState paymentState;

  const AppState({
    this.paymentState,
    this.supportedCityState,
    this.deliveryMethodState,
    this.addressState,
    this.homePageState,
    this.invoiceState,
    this.orderState,
    this.ordersState,
    this.restart,
    this.authenticationState,
    this.navigationState,
    this.errorState,
    this.loadingState,
    this.startupState,
    this.cartState,
    this.productsState,
    this.updateState,
    this.productState,
    this.mapState,
  });

  factory AppState.initial() {
    return AppState(
      restart: 0.5,
      authenticationState: AuthenticationState.initial(),
      navigationState: NavigationState.initial(),
      loadingState: LoadingState.initial(),
      errorState: ErrorState.initial(),
      startupState: StartupState.initial(),
      cartState: CartState.initial(),
      addressState: AddressState.initial(),
      invoiceState: InvoiceState.initial(),
      ordersState: OrdersState.initial(),
      orderState: OrderState.initial(),
      deliveryMethodState: DeliveryMethodState.initial(),
      productsState: ProductsState.initial(),
      updateState: UpdateState.initial(),
      productState: ProductState.initial(),
      supportedCityState: SupportedCityState.initial(),
      mapState: MapState.initial(),
      homePageState: HomePageState.initial(),
      paymentState: PaymentState.initial(),
    );
  }

  AppState copyWith({
    double restart,
    AddressState addressState,
    AuthenticationState authenticationState,
    CartState cartState,
    ErrorState errorState,
    HomePageState homePageState,
    InvoiceState invoiceState,
    LoadingState loadingState,
    NavigationState navigationState,
    OrderState orderState,
    OrdersState ordersState,
    StartupState startupState,
    DeliveryMethodState deliveryMethodState,
    ProductsState productsState,
    UpdateState updateState,
    ProductState productState,
    SupportedCityState supportedCityState,
    MapState mapState,
    PaymentState paymentState,
  }) {
    return AppState(
      restart: restart ?? this.restart,
      authenticationState: authenticationState ?? this.authenticationState,
      navigationState: navigationState ?? this.navigationState,
      errorState: errorState ?? this.errorState,
      loadingState: loadingState ?? this.loadingState,
      startupState: startupState ?? this.startupState,
      cartState: cartState ?? this.cartState,
      orderState: orderState ?? this.orderState,
      ordersState: ordersState ?? this.ordersState,
      invoiceState: invoiceState ?? this.invoiceState,
      homePageState: homePageState ?? this.homePageState,
      addressState: addressState ?? this.addressState,
      deliveryMethodState: deliveryMethodState ?? this.deliveryMethodState,
      productsState: productsState ?? this.productsState,
      updateState: updateState ?? this.updateState,
      productState: productState ?? this.productState,
      supportedCityState: supportedCityState ?? this.supportedCityState,
      mapState: mapState ?? this.mapState,
      paymentState: paymentState ?? this.paymentState,
    );
  }
}

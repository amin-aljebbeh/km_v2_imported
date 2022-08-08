import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/modules/address/redux/address_reducer.dart';
import 'package:kammun_app/modules/cart/redux/cart_reducer.dart';
import 'package:kammun_app/modules/delivery_method/redux/delivery_method_reducer.dart';
import 'package:kammun_app/modules/error/redux/error_reducer.dart';
import 'package:kammun_app/modules/home_page/redux/home_page_reducer.dart';
import 'package:kammun_app/modules/invoice/redux/invoice_reducer.dart';
import 'package:kammun_app/modules/loading/redux/loading_reducer.dart';
import 'package:kammun_app/modules/map/redux/map_reducer.dart';
import 'package:kammun_app/modules/navigation/redux/navigation_reducer.dart';
import 'package:kammun_app/modules/order/redux/order_reducer.dart';
import 'package:kammun_app/modules/orders/redux/orders_reducer.dart';
import 'package:kammun_app/modules/payment/redux/payment_reducer.dart';
import 'package:kammun_app/modules/product/redux/product_reducer.dart';
import 'package:kammun_app/modules/products/redux/products_reducer.dart';
import 'package:kammun_app/modules/supported_city/redux/supported_city_reducer.dart';
import 'package:kammun_app/modules/update/redux/update_reducer.dart';

import '../modules/authentication/redux/authentication_reducer.dart';
import '../modules/startup/redux/startup_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is RestartApp) {
    return AppState.initial();
  }
  return AppState(
    restart: state.restart,
    authenticationState: authenticationReducer(state.authenticationState, action),
    loadingState: loadingReducer(state.loadingState, action),
    errorState: errorReducer(state.errorState, action),
    navigationState: navigationReducer(state.navigationState, action),
    startupState: startupReducer(state.startupState, action),
    deliveryMethodState: deliveryMethodReducer(state.deliveryMethodState, action),
    addressState: addressReducer(state.addressState, action),
    homePageState: homePageReducer(state.homePageState, action),
    invoiceState: invoiceReducer(state.invoiceState, action),
    ordersState: ordersReducer(state.ordersState, action),
    orderState: orderReducer(state.orderState, action),
    cartState: cartReducer(state.cartState, action),
    productsState: productsReducer(state.productsState, action),
    productState: productReducer(state.productState, action),
    updateState: updateReducer(state.updateState, action),
    supportedCityState: supportedCityReducer(state.supportedCityState, action),
    mapState: mapReducer(state.mapState, action),
    paymentState: paymentReducer(state.paymentState, action),
  );
}

import 'package:kammun_app/modules/address/redux/address_middleware.dart';
import 'package:kammun_app/modules/delivery_method/redux/delivery_method_middleware.dart';
import 'package:kammun_app/modules/invoice/redux/invoice_middleware.dart';
import 'package:kammun_app/modules/loading/redux/loading_middleware.dart';
import 'package:kammun_app/modules/order/redux/order_middleware.dart';
import 'package:kammun_app/modules/orders/redux/orders_middleware.dart';
import 'package:kammun_app/modules/product/redux/product_middleware.dart';
import 'package:kammun_app/modules/products/redux/products_middleware.dart';
import 'package:kammun_app/modules/startup/redux/startup_middleware.dart';
import 'package:kammun_app/modules/supported_city/redux/supported_city_middleware.dart';
import 'package:kammun_app/modules/update/redux/update_middleware.dart';
import '../core/core_importer.dart';
import '../modules/authentication/redux/authentication_middleware.dart';
import '../modules/cart/redux/cart_middleware.dart';
import '../modules/error/redux/error_middleware.dart';
import '../modules/home_page/redux/home_page_middleware.dart';
import '../modules/map/redux/map_middleware.dart';
import '../modules/navigation/redux/navigation_middleware.dart';
import '../modules/payment/redux/payment_middleware.dart';

List<Middleware<AppState>> appMiddleware() {
  return [
    ...createNavigationMiddleware(),
    authenticationMiddleware,
    startupMiddleware,
    addressMiddleware,
    cartMiddleware,
    deliveryMethodMiddleware,
    homePageMiddleware,
    invoiceMiddleware,
    orderMiddleware,
    ordersMiddleware,
    startupMiddleware,
    productMiddleware,
    productsMiddleware,
    updateMiddleware,
    supportedCityMiddleware,
    updateMiddleware,
    loadingMiddleware,
    mapMiddleware,
    paymentMiddleware,
    errorMiddleware
  ];
}

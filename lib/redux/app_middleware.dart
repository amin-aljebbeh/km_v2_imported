import 'package:kammun_app/features/shoppers/presentation/redux/shoppers_middleware.dart';

import '../features/admins/presentation/redux/admins_middleware.dart';
import '../features/barcode/presentation/redux/barcode_middleware.dart';
import '../features/cart/presentation/redux/cart_middleware.dart';
import '../features/complaints/presentation/redux/complaints_middleware.dart';
import '../features/coupons/presentation/redux/coupon_middleware.dart';
import '../features/error/presentation/redux/error_middleware.dart';
import '../features/home/presentation/redux/home_middleware.dart';
import '../features/inventory_feature/presentation/redux/inventory_middleware.dart';
import '../features/loading/presentation/redux/loading_middleware.dart';
import '../features/order_details/presentation/redux/order_details_middleware.dart';
import '../features/orders/presentation/redux/orders_middleware.dart';
import '../features/product_details/presentation/redux/product_details_middleware.dart';
import '../features/products/presentation/redux/products_middleware.dart';
import '../features/search_orders/presentation/redux/search_orders_middleware.dart';
import '../features/general_information/presentation/redux/general_information_middleware.dart';
import '../features/supplier/presentation/redux/supplier_middleware.dart';
import '../features/transactions/presentation/redux/transactions_middleware.dart';
import '../features/users/presentation/redux/users_middleware.dart';
import 'redux_importer.dart';

List<Middleware<AppState>> appMiddleware() {
  return [
    inventoryMiddleware,
    loadingMiddleware,
    errorMiddleware,
    supplierMiddleware,
    complaintsMiddleware,
    adminsMiddleware,
    couponMiddleware,
    usersMiddleware,
    ordersMiddleware,
    transactionsMiddleware,
    shoppersMiddleware,
    searchOrdersMiddleware,
    orderDetailsMiddleware,
    cartMiddleware,
    productDetailsMiddleware,
    productsMiddleware,
    homeMiddleware,
    generalInformationMiddleware,
    barcodeMiddleware,
  ];
}

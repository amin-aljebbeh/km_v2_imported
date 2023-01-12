import 'package:kammun_app/features/admins/presentation/redux/admins_middleware.dart';
import 'package:kammun_app/features/coupons/presentation/redux/coupon_middleware.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_middleware.dart';
import 'package:kammun_app/features/loading_feature/presentation/redux/loading_middleware.dart';
import 'package:kammun_app/features/users/presentation/redux/users_middleware.dart';

import '../features/complaints/presentation/redux/complaints_middleware.dart';
import '../features/error/presentation/redux/error_middleware.dart';
import '../features/orders_feature/presentation/redux/orders_middleware.dart';
import '../features/supplier/presentation/redux/supplier_middleware.dart';
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
  ];
}

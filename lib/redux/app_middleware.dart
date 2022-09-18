import 'package:kammun_app/views/inventory_feature/presentation/redux/inventory_middleware.dart';
import 'package:kammun_app/views/loading_feature/presentation/redux/loading_middleware.dart';

import '../views/error/presentation/redux/error_middleware.dart';
import '../views/supplier/presentation/redux/supplier_middleware.dart';
import 'redux_importer.dart';

List<Middleware<AppState>> appMiddleware() {
  return [inventoryMiddleware, loadingMiddleware, errorMiddleware, supplierMiddleware];
}

import '../core/core_importer.dart';
import 'admins_injection.dart';
import 'cart_injection.dart';
import 'complaints_inject.dart';
import 'coupons_injection.dart';
import 'excel_inventory_injection.dart';
import 'home_injection.dart';
import 'inventory_injection.dart';
import 'order_details_injection.dart';
import 'orders_injection.dart';
import 'product_details_injection.dart';
import 'products_filter_injection.dart';
import 'products_injection.dart';
import 'search_orders_injection.dart';
import 'shoppers_injection.dart';
import 'supplier_injection.dart';
import 'transactions_injection.dart';
import 'users_injection.dart';

final sl = GetIt.instance;
Future<void> inject() async {
  await injectInventory();
  await injectExcelInventory();
  await injectSupplier();
  await injectComplaints();
  await injectAdmins();
  await injectCoupons();
  await injectUsers();
  await injectOrders();
  await injectSearchOrders();
  await injectTransactions();
  await injectShoppers();
  await injectOrderDetails();
  await injectCart();
  await injectProductDetails();
  await injectProducts();
  await injectHome();
  await injectProductsFilter();

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(connectionChecker: sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => RepositoryFactory(internetConnectionChecker: sl()));
}

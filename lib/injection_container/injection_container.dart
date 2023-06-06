import 'package:kammun_app/injection_container/search_orders_injection.dart';
import 'package:kammun_app/injection_container/supplier_injection.dart';
import 'package:kammun_app/injection_container/transactions_injection.dart';
import 'package:kammun_app/injection_container/users_injection.dart';

import '../core/core_importer.dart';
import 'admins_injection.dart';
import 'cart_injection.dart';
import 'complaints_inject.dart';
import 'coupons_injection.dart';
import 'inventory_injection.dart';
import 'order_details_injection.dart';
import 'orders_injection.dart';
import 'shoppers_injection.dart';

final sl = GetIt.instance;
Future<void> inject() async {
  await injectInventory();
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

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(connectionChecker: sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => RepositoryFactory(internetConnectionChecker: sl()));
}

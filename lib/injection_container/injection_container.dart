import '../core/core_importer.dart';

final sl = GetIt.instance;
Future<void> inject() async {
  await injectInventory();
  await injectSupplier();
  await injectComplaints();
  await injectAdmins();
  await injectCoupons();
  await injectUsers();

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(connectionChecker: sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

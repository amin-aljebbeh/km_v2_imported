import '../core/core_importer.dart';

final sl = GetIt.instance;
Future<void> inject() async {
  await orderInject();
  await supplierInject();
  await complaintsInject();

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(connectionChecker: sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

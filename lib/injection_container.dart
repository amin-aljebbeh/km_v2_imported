import 'core/core_importer.dart';
import 'views/inventory_feature/data/data_sources/remote_inventory_data_source.dart';
import 'views/inventory_feature/data/repositories/inventory_repository_implement.dart';
import 'views/inventory_feature/domain/repositories/inventory_repository.dart';

final sl = GetIt.instance;
Future<void> inject() async {
//authentication

//orders
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImplement(remoteInventoryDataSource: sl()));
  sl.registerLazySingleton<RemoteInventoryDataSource>(() => RemoteInventoryDataSourceImplement());

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(connectionChecker: sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

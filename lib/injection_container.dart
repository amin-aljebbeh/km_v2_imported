import 'package:kammun_app/views/supplier/data/data_sources/supplier_remote_data_source.dart';
import 'package:kammun_app/views/supplier/data/repositories/supplier_repository_implenet.dart';
import 'package:kammun_app/views/supplier/domain/repositories/supplier_repository.dart';

import 'core/core_importer.dart';
import 'views/inventory_feature/data/data_sources/remote_inventory_data_source.dart';
import 'views/inventory_feature/data/repositories/inventory_repository_implement.dart';
import 'views/inventory_feature/domain/repositories/inventory_repository.dart';

final sl = GetIt.instance;
Future<void> inject() async {
//authentication

//supplier
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepositoryImplement(supplierRemoteDataSource: sl()));
  sl.registerLazySingleton<SupplierRemoteDataSource>(() => SupplierRemoteDataSourceImplement());

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

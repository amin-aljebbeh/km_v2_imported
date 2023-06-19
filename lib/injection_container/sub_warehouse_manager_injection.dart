import '../core/core_importer.dart';
import '../features/sub_warehouse_manager/data/data_sources/sub_warehouse_local_data_source.dart';
import '../features/sub_warehouse_manager/data/data_sources/sub_warehouse_remote_data_source.dart';
import '../features/sub_warehouse_manager/data/repositories/sub_warehouse_manager_repository_implement.dart';
import '../features/sub_warehouse_manager/domain/repositories/sub_warehouse_manager_repository.dart';
import '../features/sub_warehouse_manager/domain/use_cases/import_product_activation_in_warehouse_use_case.dart';
import '../features/sub_warehouse_manager/domain/use_cases/import_product_prices_in_warehouse_use_case.dart';
import '../features/sub_warehouse_manager/domain/use_cases/pick_file_use_case.dart';
import '../features/sub_warehouse_manager/domain/use_cases/sub_warehouse_manager_use_cases.dart';
import '../features/sub_warehouse_manager/domain/use_cases/update_price_rate_threshold_use_cases.dart';

Future<void> injectSubWarehouseManager() async {
  sl.registerLazySingleton(() => ImportProductActivationInWarehouseUseCase(subWarehouseManagerRepository: sl()));
  sl.registerLazySingleton(() => ImportProductPricesInWarehouseUseCase(subWarehouseManagerRepository: sl()));
  sl.registerLazySingleton(() => UpdatePriceRateThresholdUseCase(subWarehouseManagerRepository: sl()));
  sl.registerLazySingleton(() => PickFileUseCase(subWarehouseManagerRepository: sl()));
  sl.registerLazySingleton<SubWarehouseManagerUseCases>(() => SubWarehouseManagerUseCases(
        updatePriceRateThresholdUseCase: sl(),
        pickFileUseCase: sl(),
        importProductActivationInWarehouseUseCase: sl(),
        importProductPricesInWarehouseUseCase: sl(),
      ));
  sl.registerLazySingleton<SubWarehouseManagerRepository>(() => SubWarehouseManagerRepositoryImplement(
      subWarehouseManagerRemoteDataSource: sl(), repositoryFactory: sl(), subWarehouseManagerLocaleDataSource: sl()));
  sl.registerLazySingleton<SubWarehouseManagerRemoteDataSource>(() => ExcelInventoryRemoteDataSourceImplement());
  sl.registerLazySingleton<SubWarehouseManagerLocalDataSource>(() => ExcelInventoryLocalDataSourceImplement());
}

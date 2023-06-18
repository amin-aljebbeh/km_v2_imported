import '../core/core_importer.dart';
import '../features/excel_inventory/data/data_sources/excel_inventory_remote_data_source.dart';
import '../features/excel_inventory/data/repositories/excel_inventory_repository_implement.dart';
import '../features/excel_inventory/domain/repositories/excel_inventory_repository.dart';
import '../features/excel_inventory/domain/use_cases/excel_inventory_use_cases.dart';
import '../features/excel_inventory/domain/use_cases/import_product_activation_in_warehouse_use_case.dart';
import '../features/excel_inventory/domain/use_cases/import_product_prices_in_warehouse_use_case.dart';

Future<void> injectExcelInventory() async {
  sl.registerLazySingleton(() => ImportProductActivationInWarehouseUseCase(excelInventoryRepository: sl()));
  sl.registerLazySingleton(() => ImportProductPricesInWarehouseUseCase(excelInventoryRepository: sl()));
  sl.registerLazySingleton<ExcelInventoryUseCases>(() => ExcelInventoryUseCases(
      importProductActivationInWarehouseUseCase: sl(), importProductPricesInWarehouseUseCase: sl()));
  sl.registerLazySingleton<ExcelInventoryRepository>(
      () => ExcelInventoryRepositoryImplement(excelInventoryRemoteDataSource: sl()));
  sl.registerLazySingleton<ExcelInventoryRemoteDataSource>(() => ExcelInventoryRemoteDataSourceImplement());
}

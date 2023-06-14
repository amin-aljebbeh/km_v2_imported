import '../core/core_importer.dart';
import '../features/inventory_feature/data/data_sources/remote_inventory_data_source.dart';
import '../features/inventory_feature/data/repositories/inventory_repository_implement.dart';
import '../features/inventory_feature/domain/repositories/inventory_repository.dart';
import '../features/inventory_feature/domain/use_cases/check_product_barcode_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_added_products_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_all_products_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_not_added_products_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_notification_products_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_price_changes_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_prime_products_use_case.dart';
import '../features/inventory_feature/domain/use_cases/get_sub_warehouse_products_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_under_check_availability_use_case.dart';
import '../features/inventory_feature/domain/use_cases/inventory_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/keeping_inventories_record_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/search_product_by_barcode_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/target_inventory_use_case.dart';

Future<void> injectInventory() async {
  sl.registerLazySingleton(() => GetNotificationProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetPrimeProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetUnderCheckAvailabilityUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => TargetInventoryUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => KeepingInventoriesRecordUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetNotAddedProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetAddedProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetAllProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => CheckProductsBarcodeUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => SearchProductByBarcodeUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetPriceChangesUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetSubWarehouseProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton<InventoryUseCase>(() => InventoryUseCase(
        getNotificationProductsUseCase: sl(),
        getSubWarehouseProductsUseCase: sl(),
        getPriceChangesUseCase: sl(),
        searchProductByBarcodeUseCase: sl(),
        checkProductsBarcodeUseCase: sl(),
        getAllProductsUseCase: sl(),
        getAddedProductsUseCase: sl(),
        getNotAddedProductsUseCase: sl(),
        getPrimeProductsUseCase: sl(),
        keepingInventoriesRecordUseCase: sl(),
        getUnderCheckAvailabilityUseCase: sl(),
        targetInventoryUseCase: sl(),
      ));
  sl.registerLazySingleton<InventoryRepository>(
      () => InventoryRepositoryImplement(remoteInventoryDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<RemoteInventoryDataSource>(() => RemoteInventoryDataSourceImplement());
}

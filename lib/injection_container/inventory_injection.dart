import '../core/core_importer.dart';
import '../features/inventory_feature/data/data_sources/remote_inventory_data_source.dart';
import '../features/inventory_feature/data/repositories/inventory_repository_implement.dart';
import '../features/inventory_feature/domain/repositories/inventory_repository.dart';
import '../features/inventory_feature/domain/use_cases/get_notification_products_use_cases.dart';
import '../features/inventory_feature/domain/use_cases/get_prime_products_use_case.dart';
import '../features/inventory_feature/domain/use_cases/get_under_check_availability_use_case.dart';
import '../features/inventory_feature/domain/use_cases/inventory_use_cases.dart';

Future<void> injectInventory() async {
  sl.registerLazySingleton(() => GetNotificationProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetPrimeProductsUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton(() => GetUnderCheckAvailabilityUseCase(inventoryRepository: sl()));
  sl.registerLazySingleton<InventoryUseCase>(() => InventoryUseCase(
      getNotificationProductsUseCase: sl(), getPrimeProductsUseCase: sl(), getUnderCheckAvailabilityUseCase: sl()));
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImplement(remoteInventoryDataSource: sl()));
  sl.registerLazySingleton<RemoteInventoryDataSource>(() => RemoteInventoryDataSourceImplement());
}

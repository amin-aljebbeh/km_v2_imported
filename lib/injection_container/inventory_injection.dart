import '../core/core_importer.dart';
import '../features/inventory_feature/data/data_sources/remote_inventory_data_source.dart';
import '../features/inventory_feature/data/repositories/inventory_repository_implement.dart';
import '../features/inventory_feature/domain/repositories/inventory_repository.dart';

Future<void> injectInventory() async {
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImplement(remoteInventoryDataSource: sl()));
  sl.registerLazySingleton<RemoteInventoryDataSource>(() => RemoteInventoryDataSourceImplement());
}

import '../core/core_importer.dart';
import '../views/inventory_feature/data/data_sources/remote_inventory_data_source.dart';
import '../views/inventory_feature/data/repositories/inventory_repository_implement.dart';
import '../views/inventory_feature/domain/repositories/inventory_repository.dart';

Future<void> orderInject() async {
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImplement(remoteInventoryDataSource: sl()));
  sl.registerLazySingleton<RemoteInventoryDataSource>(() => RemoteInventoryDataSourceImplement());
}

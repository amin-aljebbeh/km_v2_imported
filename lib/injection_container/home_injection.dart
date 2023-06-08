import '../core/core_importer.dart';
import '../features/home/data/data_sources/home_inventory_data_source.dart';
import '../features/home/data/repositories/home_repository_implement.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/use_cases/home_use_cases.dart';

Future<void> injectHome() async {
  sl.registerLazySingleton<HomeUseCases>(() => HomeUseCases());
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImplement(homeInventoryDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImplement());
}

import 'package:kammun_app/features/shoppers/domain/use_cases/shoppers_use_case.dart';

import '../core/core_importer.dart';
import '../features/shoppers/data/data_sources/shoppers_remote_data_source.dart';
import '../features/shoppers/data/repositories/shoppers_repository_implement.dart';
import '../features/shoppers/domain/repositories/shoppers_repository.dart';

Future<void> injectShoppers() async {
  sl.registerLazySingleton<ShoppersUseCase>(() => ShoppersUseCase());
  sl.registerLazySingleton<ShoppersRepository>(
      () => ShoppersRepositoryImplement(shoppersRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<ShoppersRemoteDataSource>(() => ShoppersRemoteDataSourceImplement());
}

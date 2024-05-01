import 'package:kammun_app/features/version/data/data_sources/version_remote_data_source.dart';
import 'package:kammun_app/features/version/data/repositories/version_repository_implement.dart';
import 'package:kammun_app/features/version/domain/repositories/version_repository.dart';

import '../core/core_importer.dart';
import '../features/version/domain/use_cases/check_version_use_case.dart';
import '../features/version/domain/use_cases/version_use_cases.dart';

Future<void> versionUsers() async {
  sl.registerLazySingleton(() => CheckVersionUseCase(versionRepository: sl()));

  sl.registerLazySingleton<VersionUseCases>(() => VersionUseCases(checkVersionUseCase: sl()));
  sl.registerLazySingleton<VersionRepository>(
      () => VersionRepositoryImplement(versionRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<VersionRemoteDataSource>(() => VersionRemoteDataSourceImplement());
}

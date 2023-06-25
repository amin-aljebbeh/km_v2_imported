import '../core/core_importer.dart';
import '../features/authentication/data/data_sources/authentication_remote_data_source.dart';
import '../features/authentication/data/repositories/authentication_repository_implement.dart';
import '../features/authentication/domain/repositories/authentication_repository.dart';
import '../features/authentication/domain/use_cases/authentication_cases.dart';
import '../features/authentication/domain/use_cases/login_use_case.dart';
import '../features/authentication/domain/use_cases/logout_use_case.dart';

Future<void> injectAuth() async {
  sl.registerLazySingleton(() => LoginUseCase(authenticationRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authenticationRepository: sl()));
  sl.registerLazySingleton<AuthenticationUseCases>(
      () => AuthenticationUseCases(loginUseCase: sl(), logoutUseCase: sl()));
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplement(authenticationRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImplement());
}

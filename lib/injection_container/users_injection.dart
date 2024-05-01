import 'package:kammun_app/features/users/domain/use_cases/attach_user_to_coupon_use_case.dart';
import 'package:kammun_app/features/users/domain/use_cases/change_number_phone_use_case.dart';

import '../core/core_importer.dart';
import '../features/users/data/data_sources/users_remote_data_source.dart';
import '../features/users/data/repositories/users_repository_implement.dart';
import '../features/users/domain/repositories/users_repository.dart';
import '../features/users/domain/use_cases/users_use_cases.dart';

Future<void> injectUsers() async {
  sl.registerLazySingleton(() => AttachUserToCouponUseCase(usersRepository: sl()));
  sl.registerLazySingleton(() => ChangeNumberPhoneUserUseCase(usersRepository: sl()));

  sl.registerLazySingleton<UsersUseCases>(
      () => UsersUseCases(attachUserToCouponUseCase: sl(), changeNumberPhoneUserUseCase: sl()));
  sl.registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImplement(usersRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<UsersRemoteDataSource>(() => UsersRemoteDataSourceImplement());
}

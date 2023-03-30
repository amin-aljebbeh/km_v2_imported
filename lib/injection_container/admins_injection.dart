import 'package:kammun_app/features/admins/domain/use_cases/get_transactions_actors_use_case.dart';

import '../core/core_importer.dart';
import '../features/admins/data/data_sources/admins_remote_data_source.dart';
import '../features/admins/data/repositories/admins_repository_implement.dart';
import '../features/admins/domain/repositories/admins_repository.dart';
import '../features/admins/domain/use_cases/admins_use_cases.dart';
import '../features/admins/domain/use_cases/get_admins_use_case.dart';
import '../features/admins/domain/use_cases/get_roles_use_case.dart';

Future<void> injectAdmins() async {
  sl.registerLazySingleton(() => GetAdminsWithoutDetailsUseCase(adminsRepository: sl()));
  sl.registerLazySingleton(() => GetTransactionsActorsUseCase(adminsRepository: sl()));
  sl.registerLazySingleton(() => GetRolesUseCase(adminsRepository: sl()));
  sl.registerLazySingleton<AdminsUseCases>(() =>
      AdminsUseCases(getAdminsWithoutDetailsUseCase: sl(), getTransactionsActorsUseCase: sl(), getRolesUseCase: sl()));
  sl.registerLazySingleton<AdminsRepository>(() => AdminsRepositoryImplement(adminsRemoteDataSource: sl()));
  sl.registerLazySingleton<AdminsRemoteDataSource>(() => AdminsRemoteDataSourceImplement());
}

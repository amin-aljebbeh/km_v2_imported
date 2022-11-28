import '../core/core_importer.dart';
import '../views/complaints/data/data_sources/complaints_remote_data_source.dart';
import '../views/complaints/data/repositories/complaints_repository_implement.dart';
import '../views/complaints/domain/repositories/complaints_repository.dart';
import '../views/complaints/domain/use_cases/complaints_usecases.dart';
import '../views/complaints/domain/use_cases/get_complaints_use_case.dart';

Future<void> complaintsInject() async {
  sl.registerLazySingleton(() => GetComplaintsUseCase(complaintsRepository: sl()));
  sl.registerLazySingleton<ComplaintsUseCases>(() => ComplaintsUseCases(getComplaintUseCase: sl()));
  sl.registerLazySingleton<ComplaintsRepository>(() => ComplaintsRepositoryImplement(complaintsRemoteDataSource: sl()));
  sl.registerLazySingleton<ComplaintsRemoteDataSource>(() => ComplaintsRemoteDataSourceImplement());
}

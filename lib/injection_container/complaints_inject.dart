import 'package:kammun_app/features/complaints/domain/use_cases/complaints_use_cases_importer.dart';

import '../core/core_importer.dart';
import '../features/complaints/data/data_sources/complaints_remote_data_source.dart';
import '../features/complaints/data/repositories/complaints_repository_implement.dart';
import '../features/complaints/domain/repositories/complaints_repository.dart';

Future<void> injectComplaints() async {
  sl.registerLazySingleton(() => GetComplaintsUseCase(complaintsRepository: sl()));
  sl.registerLazySingleton(() => GetComplaintTypeUSeCase(complaintsRepository: sl()));
  sl.registerLazySingleton(() => CreateComplaintUseCase(complaintsRepository: sl()));
  sl.registerLazySingleton(() => ChangeComplaintStatusUseCase(complaintsRepository: sl()));
  sl.registerLazySingleton<ComplaintsUseCases>(() => ComplaintsUseCases(
      getComplaintUseCase: sl(),
      getComplaintTypeUSeCase: sl(),
      createComplaintUseCase: sl(),
      changeComplaintStatusUseCase: sl()));
  sl.registerLazySingleton<ComplaintsRepository>(() => ComplaintsRepositoryImplement(complaintsRemoteDataSource: sl()));
  sl.registerLazySingleton<ComplaintsRemoteDataSource>(() => ComplaintsRemoteDataSourceImplement());
}

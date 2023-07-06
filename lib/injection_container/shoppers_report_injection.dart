import '../core/core_importer.dart';
import '../features/shoppers_reports/data/data_sources/shoppers_reports_remote_data_source.dart';
import '../features/shoppers_reports/data/repositories/shoppers_reports_repository_implement.dart';
import '../features/shoppers_reports/domain/repositories/shoppers_reports_repository.dart';
import '../features/shoppers_reports/domain/use_cases/get_monthly_shopper_reports_use_case.dart';
import '../features/shoppers_reports/domain/use_cases/get_shopper_activity_hours_use_case.dart';
import '../features/shoppers_reports/domain/use_cases/get_shopper_working_hours_use_case.dart';
import '../features/shoppers_reports/domain/use_cases/shoppers_reports_use_cases.dart';

Future<void> injectShoppersReports() async {
  sl.registerLazySingleton(() => GetMonthlyShopperReportsUseCase(shoppersReportsRepository: sl()));
  sl.registerLazySingleton(() => GetShopperActivityHoursUseCase(shoppersReportsRepository: sl()));
  sl.registerLazySingleton(() => GetShopperWorkingHoursUseCase(shoppersReportsRepository: sl()));
  sl.registerLazySingleton<ShoppersReportsUseCases>(() => ShoppersReportsUseCases(
        getMonthlyShopperReportsUseCase: sl(),
        getShopperActivityHoursUseCase: sl(),
        getShopperWorkingHoursUseCase: sl(),
      ));
  sl.registerLazySingleton<ShoppersReportsRepository>(
      () => ShoppersReportsRepositoryImplement(shoppersReportsRemoteDataSource: sl()));
  sl.registerLazySingleton<ShoppersReportsRemoteDataSource>(() => ShoppersReportsRemoteDataSourceImplement());
}

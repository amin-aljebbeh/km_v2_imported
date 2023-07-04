import '../core/core_importer.dart';
import '../features/report/data/data_sources/reports_remote_data_source.dart';
import '../features/report/data/repositories/reports_repository_implement.dart';
import '../features/report/domain/repositories/reports_repository.dart';
import '../features/report/domain/use_cases/get_financial_report_use_case.dart';
import '../features/report/domain/use_cases/get_sales_reports_use_case.dart';
import '../features/report/domain/use_cases/reports_use_cases.dart';

Future<void> injectReports() async {
  sl.registerLazySingleton(() => GetFinancialReportUseCase(reportsRepository: sl()));
  sl.registerLazySingleton(() => GetSalesReportsUseCase(reportsRepository: sl()));
  sl.registerLazySingleton<ReportsUseCases>(
      () => ReportsUseCases(getFinancialReportUseCase: sl(), getSalesReportsUseCase: sl()));
  sl.registerLazySingleton<ReportsRepository>(() => ReportsRepositoryImplement(reportsRemoteDateSource: sl()));
  sl.registerLazySingleton<ReportsRemoteDateSource>(() => ReportsRemoteDateSourceImplement());
}

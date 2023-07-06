import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/reports/domain/entities/get_daily_statistics_entity.dart';

import '../entities/financial_report_entity.dart';

abstract class ReportsRepository {
  Future<Either<Failure, DailyStatisticsEntity>> getSalesReports({String fromDate, String toDate});

  Future<Either<Failure, FinancialReportEntity>> getFinancialReport({String fromDate, String toDate});
}

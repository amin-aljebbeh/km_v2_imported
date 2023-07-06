import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/reports/data/data_sources/reports_remote_data_source.dart';
import 'package:kammun_app/features/reports/domain/entities/financial_report_entity.dart';
import 'package:kammun_app/features/reports/domain/entities/get_daily_statistics_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/reports_repository.dart';

class ReportsRepositoryImplement implements ReportsRepository {
  final ReportsRemoteDataSource reportsRemoteDateSource;

  ReportsRepositoryImplement({this.reportsRemoteDateSource});

  @override
  Future<Either<Failure, FinancialReportEntity>> getFinancialReport({String fromDate, String toDate}) async {
    try {
      FinancialReportEntity report =
          await reportsRemoteDateSource.getFinancialReport(fromDate: fromDate, toDate: toDate);
      return Right(report);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailyStatisticsEntity>> getSalesReports({String fromDate, String toDate}) async {
    try {
      DailyStatisticsEntity statistics =
          await reportsRemoteDateSource.getSalesReports(fromDate: fromDate, toDate: toDate);
      return Right(statistics);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/shoppers_reports/data/data_sources/shoppers_reports_remote_data_source.dart';
import 'package:kammun_app/features/shoppers_reports/domain/entities/shopper_monthly_report_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/activity_hours_entity.dart';
import '../../domain/entities/shopper_working_hours_entity.dart';
import '../../domain/repositories/shoppers_reports_repository.dart';

class ShoppersReportsRepositoryImplement implements ShoppersReportsRepository {
  final ShoppersReportsRemoteDataSource shoppersReportsRemoteDataSource;

  ShoppersReportsRepositoryImplement({this.shoppersReportsRemoteDataSource});

  @override
  Future<Either<Failure, List<ShopperMonthlyReportEntity>>> getMonthlyShopperReports({String shopperId}) async {
    try {
      List<ShopperMonthlyReportEntity> report =
          await shoppersReportsRemoteDataSource.getMonthlyShopperReports(shopperId: shopperId);
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
  Future<Either<Failure, List<ActivityHoursEntity>>> getShopperActivityHours(
      {String shopperId, String fromDate, String toDate}) async {
    try {
      List<ActivityHoursEntity> report = await shoppersReportsRemoteDataSource.getShopperActivityHours(
          shopperId: shopperId, fromDate: fromDate, toDate: toDate);
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
  Future<Either<Failure, List<ShopperWorkingHoursEntity>>> getShopperWorkingHours(
      {String shopperId, String filterBy}) async {
    try {
      List<ShopperWorkingHoursEntity> report =
          await shoppersReportsRemoteDataSource.getShopperWorkingHours(shopperId: shopperId, filterBy: filterBy);
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
}

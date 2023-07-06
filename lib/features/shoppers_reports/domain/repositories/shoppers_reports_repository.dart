import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../entities/activity_hours_entity.dart';
import '../entities/shopper_monthly_report_entity.dart';
import '../entities/shopper_working_hours_entity.dart';

abstract class ShoppersReportsRepository {
  Future<Either<Failure, List<ActivityHoursEntity>>> getShopperActivityHours(
      {String shopperId, String fromDate, String toDate});

  Future<Either<Failure, List<ShopperWorkingHoursEntity>>> getShopperWorkingHours({String shopperId, String filterBy});

  Future<Either<Failure, List<ShopperMonthlyReportEntity>>> getMonthlyShopperReports({String shopperId});
}

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/shoppers_reports/domain/repositories/shoppers_reports_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/activity_hours_entity.dart';

class GetShopperActivityHoursUseCase {
  final ShoppersReportsRepository shoppersReportsRepository;

  GetShopperActivityHoursUseCase({this.shoppersReportsRepository});

  Future<Either<Failure, List<ActivityHoursEntity>>> call({String shopperId, String fromDate, String toDate}) async {
    return await shoppersReportsRepository.getShopperActivityHours(
        shopperId: shopperId, toDate: toDate, fromDate: fromDate);
  }
}

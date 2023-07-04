import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/report/domain/repositories/reports_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/get_daily_statistics_entity.dart';

class GetSalesReportsUseCase {
  final ReportsRepository reportsRepository;

  GetSalesReportsUseCase({this.reportsRepository});

  Future<Either<Failure, DailyStatisticsEntity>> call({String fromDate, String toDate}) async {
    return await reportsRepository.getSalesReports(toDate: toDate, fromDate: fromDate);
  }
}

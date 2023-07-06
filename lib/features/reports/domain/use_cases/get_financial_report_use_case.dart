import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/reports/domain/repositories/reports_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/financial_report_entity.dart';

class GetFinancialReportUseCase {
  final ReportsRepository reportsRepository;

  GetFinancialReportUseCase({this.reportsRepository});

  Future<Either<Failure, FinancialReportEntity>> call({String fromDate, String toDate}) async {
    return await reportsRepository.getFinancialReport(toDate: toDate, fromDate: fromDate);
  }
}

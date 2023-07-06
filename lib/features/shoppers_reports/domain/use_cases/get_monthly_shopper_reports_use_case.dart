import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/shoppers_reports/domain/repositories/shoppers_reports_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/shopper_monthly_report_entity.dart';

class GetMonthlyShopperReportsUseCase {
  final ShoppersReportsRepository shoppersReportsRepository;

  GetMonthlyShopperReportsUseCase({this.shoppersReportsRepository});

  Future<Either<Failure, List<ShopperMonthlyReportEntity>>> call({String shopperId}) async {
    return await shoppersReportsRepository.getMonthlyShopperReports(shopperId: shopperId);
  }
}

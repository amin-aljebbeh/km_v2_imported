import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/shoppers_reports/domain/repositories/shoppers_reports_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/shopper_working_hours_entity.dart';

class GetShopperWorkingHoursUseCase {
  final ShoppersReportsRepository shoppersReportsRepository;

  GetShopperWorkingHoursUseCase({this.shoppersReportsRepository});

  Future<Either<Failure, List<ShopperWorkingHoursEntity>>> call({String shopperId, String filterBy}) async {
    return await shoppersReportsRepository.getShopperWorkingHours(shopperId: shopperId,filterBy: filterBy);
  }
}

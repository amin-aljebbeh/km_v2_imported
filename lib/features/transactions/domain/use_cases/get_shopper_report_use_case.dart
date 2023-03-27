import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/shopper_report_entity.dart';

class GetShopperReportUseCase {
  final TransactionsRepository transactionsRepository;

  GetShopperReportUseCase({this.transactionsRepository});

  Future<Either<Failure, ShopperReportEntity>> call({int shopperId}) async {
    return await transactionsRepository.getShopperReport(shopperId: shopperId);
  }
}

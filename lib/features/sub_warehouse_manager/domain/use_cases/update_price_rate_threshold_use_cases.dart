import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../repositories/sub_warehouse_manager_repository.dart';

class UpdatePriceRateThresholdUseCase {
  final SubWarehouseManagerRepository subWarehouseManagerRepository;

  UpdatePriceRateThresholdUseCase({this.subWarehouseManagerRepository});

  Future<Either<Failure, Unit>> call({String threshold}) async {
    return await subWarehouseManagerRepository.updatePriceRateThreshold(threshold: threshold);
  }
}

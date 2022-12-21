import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';

class GetUnderCheckAvailabilityUseCase {
  final InventoryRepository inventoryRepository;

  GetUnderCheckAvailabilityUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductData>>> call({int subWarehouseId}) async {
    return await inventoryRepository.getUnderCheckAvailability(subWarehouseId: subWarehouseId);
  }
}

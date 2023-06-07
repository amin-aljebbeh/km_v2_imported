import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

class GetUnderCheckAvailabilityUseCase {
  final InventoryRepository inventoryRepository;

  GetUnderCheckAvailabilityUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductEntity>>> call({int subWarehouseId}) async {
    return await inventoryRepository.getUnderCheckAvailability(subWarehouseId: subWarehouseId);
  }
}

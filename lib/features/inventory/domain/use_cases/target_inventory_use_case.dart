import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';

class TargetInventoryUseCase {
  final InventoryRepository inventoryRepository;

  TargetInventoryUseCase({this.inventoryRepository});

  Future<Either<Failure, Unit>> call() async {
    return await inventoryRepository.targetInventory();
  }
}

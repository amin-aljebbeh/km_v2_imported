import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/prices_changes_entity.dart';

class GetPriceChangesUseCase {
  final InventoryRepository inventoryRepository;

  GetPriceChangesUseCase({this.inventoryRepository});

  Future<Either<Failure, PricesChangesEntity>> call() async {
    return await inventoryRepository.getPriceChanges();
  }
}

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';

class KeepingInventoriesRecordUseCase {
  final InventoryRepository inventoryRepository;

  KeepingInventoriesRecordUseCase({this.inventoryRepository});

  Future<Either<Failure, Unit>> call() async {
    return await inventoryRepository.keepingAnInventoriesRecord();
  }
}

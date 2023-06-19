import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

class GetSubWarehouseProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetSubWarehouseProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductEntity>>> call({int subWarehouseId}) async {
    return await inventoryRepository.getSubWarehouseProducts(subWarehouseId: subWarehouseId);
  }
}

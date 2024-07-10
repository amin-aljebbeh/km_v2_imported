import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

class GetErrorProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetErrorProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await inventoryRepository.getErrorOrders();
  }
}

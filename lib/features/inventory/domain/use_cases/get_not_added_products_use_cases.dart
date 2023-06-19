import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

class GetNotAddedProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetNotAddedProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await inventoryRepository.getNotAddedProducts();
  }
}

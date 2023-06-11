import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';

class GetNotAddedProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetNotAddedProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await inventoryRepository.getNotAddedProducts();
  }
}

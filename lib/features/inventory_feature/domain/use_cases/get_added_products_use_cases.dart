import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';

class GetAddedProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetAddedProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await inventoryRepository.getAddedProducts();
  }
}

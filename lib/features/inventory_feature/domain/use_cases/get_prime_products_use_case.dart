import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/filtered_products_model.dart';

class GetPrimeProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetPrimeProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, FilteredProductsModel>> call({int pageNumber, int subWarehouseId, int isActive}) async {
    return await inventoryRepository.getPrimeProducts(
        subWarehouseId: subWarehouseId, isActive: isActive, pageNumber: pageNumber);
  }
}

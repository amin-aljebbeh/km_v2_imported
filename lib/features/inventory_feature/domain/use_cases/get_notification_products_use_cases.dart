import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../products_filter/domain/entities/products_pagination_entity.dart';

class GetNotificationProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetNotificationProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, ProductsPaginationEntity>> call({int pageNumber, int subWarehouseId, int isActive}) async {
    return await inventoryRepository.getNotificationProducts(
        pageNumber: pageNumber, subWarehouseId: subWarehouseId, isActive: isActive);
  }
}

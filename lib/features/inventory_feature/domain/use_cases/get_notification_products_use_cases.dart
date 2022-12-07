import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';

class GetNotificationProductsUseCase {
  final InventoryRepository inventoryRepository;

  GetNotificationProductsUseCase({this.inventoryRepository});

  Future<Either<Failure, FilteredProductsModel>> call({int pageNumber}) async {
    return await inventoryRepository.getNotificationProducts(pageNumber: pageNumber);
  }
}

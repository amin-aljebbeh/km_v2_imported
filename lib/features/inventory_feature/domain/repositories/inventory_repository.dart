import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';

abstract class InventoryRepository {
  Future<Either<Failure, FilteredProductsModel>> getNotificationProducts({int pageNumber});
  Future<Either<Failure, FilteredProductsModel>> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive});
  Future<Either<Failure, List<ProductData>>> getUnderCheckAvailability({int subWarehouseId});
}

import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, FilteredProductsModel>> getNotificationProducts(
      {int pageNumber, int subWarehouseId, int isActive});

  Future<Either<Failure, FilteredProductsModel>> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive});

  Future<Either<Failure, List<ProductEntity>>> getUnderCheckAvailability({int subWarehouseId});

  Future<Either<Failure, Unit>> targetInventory();

  Future<Either<Failure, Unit>> keepingAnInventoriesRecord();

  Future<Either<Failure, List<ProductModel>>> getAllProducts();

  Future<Either<Failure, List<ProductModel>>> getNotAddedProducts();

  Future<Either<Failure, List<ProductModel>>> getAddedProducts();
}

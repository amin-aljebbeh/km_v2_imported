import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/entities/prices_changes_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import '../../../products/domain/entities/product_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, FilteredProductsModel>> getNotificationProducts(
      {int pageNumber, int subWarehouseId, int isActive});

  Future<Either<Failure, FilteredProductsModel>> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive});

  Future<Either<Failure, List<ProductEntity>>> getUnderCheckAvailability({int subWarehouseId});

  Future<Either<Failure, Unit>> targetInventory();

  Future<Either<Failure, Unit>> keepingAnInventoriesRecord();

  Future<Either<Failure, List<ProductEntity>>> getAllProducts();

  Future<Either<Failure, List<ProductEntity>>> getNotAddedProducts();

  Future<Either<Failure, List<ProductEntity>>> getAddedProducts();

  Future<Either<Failure, List<ProductEntity>>> checkProductBarcode({String barcode});

  Future<Either<Failure, List<ProductEntity>>> searchProductByBarcode({String barcode});

  Future<Either<Failure, PricesChangesEntity>> getPriceChanges();
}

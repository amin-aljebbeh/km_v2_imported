import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory/domain/entities/prices_changes_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products_filter/domain/entities/products_pagination_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, ProductsPaginationEntity>> getNotificationProducts(
      {int pageNumber, int subWarehouseId, int isActive});

  Future<Either<Failure, ProductsPageEntity>> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive});

  Future<Either<Failure, List<ProductEntity>>> getUnderCheckAvailability({int subWarehouseId});

  Future<Either<Failure, List<ProductEntity>>> getErrorOrders();

  Future<Either<Failure, Unit>> targetInventory();

  Future<Either<Failure, Unit>> keepingAnInventoriesRecord();

  Future<Either<Failure, List<ProductEntity>>> getAllProducts();

  Future<Either<Failure, List<ProductEntity>>> getNotAddedProducts();

  Future<Either<Failure, List<ProductEntity>>> getAddedProducts();

  Future<Either<Failure, List<ProductEntity>>> checkProductBarcode({String barcode});

  Future<Either<Failure, List<ProductEntity>>> searchProductByBarcode({String barcode});

  Future<Either<Failure, List<ProductEntity>>> getSubWarehouseProducts({int subWarehouseId});

  Future<Either<Failure, PricesChangesEntity>> getPriceChanges();
}

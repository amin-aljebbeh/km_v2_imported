import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/entities/inventory_file_product_entity.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/entities/price_file_product_entity.dart';

import '../../../../core/core_importer.dart';

abstract class SubWarehouseManagerRepository {
  Future<Either<Failure, PriceFileProductEntity>> importProductPricesInWarehouse({String subWarehouseId, File file});

  Future<Either<Failure, Unit>> updatePriceRateThreshold({String threshold});

  Future<Either<Failure, File>> pickFile();

  Future<Either<Failure, InventoryFileProductEntity>> importProductActivationInWarehouse(
      {String subWarehouseId, File file});
}

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/excel_inventory/domain/entities/inventory_file_product_entity.dart';
import 'package:kammun_app/features/excel_inventory/domain/entities/price_file_product_entity.dart';

import '../../../../core/core_importer.dart';

abstract class ExcelInventoryRepository {
  Future<Either<Failure, PriceFileProductEntity>> importProductPricesInWarehouse({String subWarehouseId, File file});

  Future<Either<Failure, InventoryFileProductEntity>> importProductActivationInWarehouse(
      {String subWarehouseId, File file});
}

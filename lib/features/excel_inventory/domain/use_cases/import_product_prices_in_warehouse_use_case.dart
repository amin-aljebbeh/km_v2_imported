import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/excel_inventory/domain/repositories/excel_inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/price_file_product_entity.dart';

class ImportProductPricesInWarehouseUseCase {
  final ExcelInventoryRepository excelInventoryRepository;

  ImportProductPricesInWarehouseUseCase({this.excelInventoryRepository});

  Future<Either<Failure, PriceFileProductEntity>> call({String subWarehouseId, File file}) async {
    return await excelInventoryRepository.importProductPricesInWarehouse(subWarehouseId: subWarehouseId, file: file);
  }
}

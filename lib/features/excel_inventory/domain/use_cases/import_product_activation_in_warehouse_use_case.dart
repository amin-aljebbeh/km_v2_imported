import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/excel_inventory/domain/repositories/excel_inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/inventory_file_product_entity.dart';

class ImportProductActivationInWarehouseUseCase {
  final ExcelInventoryRepository excelInventoryRepository;

  ImportProductActivationInWarehouseUseCase({this.excelInventoryRepository});

  Future<Either<Failure, InventoryFileProductEntity>> call({String subWarehouseId, File file}) async {
    return await excelInventoryRepository.importProductActivationInWarehouse(
        subWarehouseId: subWarehouseId, file: file);
  }
}

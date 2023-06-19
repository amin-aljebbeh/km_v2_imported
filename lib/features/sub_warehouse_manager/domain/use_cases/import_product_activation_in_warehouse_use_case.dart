import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/repositories/sub_warehouse_manager_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/inventory_file_product_entity.dart';

class ImportProductActivationInWarehouseUseCase {
  final SubWarehouseManagerRepository subWarehouseManagerRepository;

  ImportProductActivationInWarehouseUseCase({this.subWarehouseManagerRepository});

  Future<Either<Failure, InventoryFileProductEntity>> call({String subWarehouseId, File file}) async {
    return await subWarehouseManagerRepository.importProductActivationInWarehouse(
        subWarehouseId: subWarehouseId, file: file);
  }
}

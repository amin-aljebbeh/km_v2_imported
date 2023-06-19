import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/repositories/sub_warehouse_manager_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/price_file_product_entity.dart';

class ImportProductPricesInWarehouseUseCase {
  final SubWarehouseManagerRepository subWarehouseManagerRepository;

  ImportProductPricesInWarehouseUseCase({this.subWarehouseManagerRepository});

  Future<Either<Failure, PriceFileProductEntity>> call({String subWarehouseId, File file}) async {
    return await subWarehouseManagerRepository.importProductPricesInWarehouse(
        subWarehouseId: subWarehouseId, file: file);
  }
}

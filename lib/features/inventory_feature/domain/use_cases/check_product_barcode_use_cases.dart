import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';

class CheckProductsBarcodeUseCase {
  final InventoryRepository inventoryRepository;

  CheckProductsBarcodeUseCase({this.inventoryRepository});

  Future<Either<Failure, List<ProductEntity>>> call({String barcode}) async {
    return await inventoryRepository.checkProductBarcode(barcode: barcode);
  }
}

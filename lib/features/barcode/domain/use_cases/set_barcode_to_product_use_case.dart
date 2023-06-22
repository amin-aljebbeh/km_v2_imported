import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/barcode/domain/repositories/barcode_repository.dart';

import '../../../../core/core_importer.dart';

class SetBarcodeToProductUseCase {
  final BarcodeRepository barcodeRepository;

  SetBarcodeToProductUseCase({this.barcodeRepository});
  Future<Either<Failure, String>> call({int barcode, int productId}) async {
    return await barcodeRepository.setBarcodeToProduct(barcode: barcode, productId: productId);
  }
}

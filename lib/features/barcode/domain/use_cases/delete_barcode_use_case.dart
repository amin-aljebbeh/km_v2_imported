import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/barcode/domain/repositories/barcode_repository.dart';

import '../../../../core/core_importer.dart';

class DeleteBarcodeUseCase {
  final BarcodeRepository barcodeRepository;

  DeleteBarcodeUseCase({this.barcodeRepository});

  Future<Either<Failure, Unit>> call({String barcodeId}) async {
    return await barcodeRepository.deleteBarcode(barcodeId: barcodeId);
  }
}

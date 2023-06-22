import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

abstract class BarcodeRepository {
  Future<Either<Failure, String>> setBarcodeToProduct({int barcode, int productId});

  Future<Either<Failure, Unit>> deleteBarcode({String barcodeId});
}

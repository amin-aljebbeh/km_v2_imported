import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, Unit>> deleteProduct({int productId});

  Future<Either<Failure, Unit>> deleteImage({int imageId});
}

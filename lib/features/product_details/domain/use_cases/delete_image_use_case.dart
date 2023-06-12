import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/product_details/domain/repositories/product_details_repository.dart';

import '../../../../core/core_importer.dart';

class DeleteImageUseCase {
  final ProductDetailsRepository productDetailsRepository;

  DeleteImageUseCase({this.productDetailsRepository});

  Future<Either<Failure, Unit>> call({int imageId}) async {
    return await productDetailsRepository.deleteImage(imageId: imageId);
  }
}

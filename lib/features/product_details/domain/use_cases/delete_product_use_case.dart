import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/product_details/domain/repositories/product_details_repository.dart';

import '../../../../core/core_importer.dart';

class DeleteProductUseCase {
  final ProductDetailsRepository productDetailsRepository;

  DeleteProductUseCase({this.productDetailsRepository});

  Future<Either<Failure, Unit>> call({int productId}) async {
    return await productDetailsRepository.deleteProduct(productId: productId);
  }
}

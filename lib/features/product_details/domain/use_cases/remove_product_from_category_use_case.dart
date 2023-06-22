import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/product_details/domain/repositories/product_details_repository.dart';

import '../../../../core/core_importer.dart';

class RemoveProductFromCategoryUseCase {
  final ProductDetailsRepository productDetailsRepository;

  RemoveProductFromCategoryUseCase({this.productDetailsRepository});

  Future<Either<Failure, Unit>> call({String productId, String categoryId}) async {
    return await productDetailsRepository.removeProductFromCategory(productId: productId, categoryId: categoryId);
  }
}

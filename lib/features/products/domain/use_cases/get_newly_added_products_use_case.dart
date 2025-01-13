import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products/domain/repositories/products_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/category_products_pagination_entity.dart';

class GetNewlyAddedProductsUseCase {
  final ProductsRepository productsRepository;

  GetNewlyAddedProductsUseCase({this.productsRepository});

  Future<Either<Failure, CategoryProductsPaginationEntity>> call({int pageNumber}) async {
    return await productsRepository.getNewlyAddedProducts(pageNumber: pageNumber);
  }
}

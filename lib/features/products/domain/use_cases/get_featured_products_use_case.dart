import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/category_products_pagination_entity.dart';
import '../repositories/products_repository.dart';

class GetFeaturedProductsUseCase {
  final ProductsRepository productsRepository;

  GetFeaturedProductsUseCase({this.productsRepository});

  Future<Either<Failure, CategoryProductsPaginationEntity>> call({int pageNumber}) async {
    return await productsRepository.getFeaturedProducts(pageNumber: pageNumber);
  }
}

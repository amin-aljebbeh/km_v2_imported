import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products/domain/repositories/products_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/category_products_entity.dart';

class GetCategoryProductsUseCase {
  final ProductsRepository productsRepository;

  GetCategoryProductsUseCase({this.productsRepository});

  Future<Either<Failure, CategoryProductsEntity>> call({int categoryId, int pageNumber}) async {
    return await productsRepository.getCategoryProducts(categoryId: categoryId, pageNumber: pageNumber);
  }
}

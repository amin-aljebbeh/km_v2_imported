import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products/domain/repositories/products_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/category_products_entity.dart';

class SearchProductsUseCase {
  final ProductsRepository productsRepository;

  SearchProductsUseCase({this.productsRepository});

  Future<Either<Failure, CategoryProductsEntity>> call({String query, int pageNumber}) async {
    return await productsRepository.searchProducts(query: query, pageNumber: pageNumber);
  }
}

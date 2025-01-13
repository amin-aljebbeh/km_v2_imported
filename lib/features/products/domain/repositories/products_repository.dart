import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../entities/category_products_entity.dart';
import '../entities/category_products_pagination_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, CategoryProductsEntity>> getCategoryProducts({int categoryId, int pageNumber});
  Future<Either<Failure, CategoryProductsEntity>> searchProducts({String query, int pageNumber});
  Future<Either<Failure, List<ProductEntity>>> getBarcodeProducts({String barcode});
  Future<Either<Failure, CategoryProductsPaginationEntity>> getFeaturedProducts({int pageNumber});
  Future<Either<Failure, CategoryProductsPaginationEntity>> getNewlyAddedProducts({int pageNumber});
}

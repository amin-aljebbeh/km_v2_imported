import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products/data/data_sources/products_remote_data_source.dart';
import 'package:kammun_app/features/products/domain/entities/category_products_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImplement implements ProductsRepository {
  final ProductsRemoteDataSource productsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  ProductsRepositoryImplement({this.productsRemoteDataSource, this.repositoryFactory});
  @override
  Future<Either<Failure, List<ProductEntity>>> getBarcodeProducts({String barcode}) async {
    try {
      List<ProductEntity> products = await productsRemoteDataSource.getBarcodeProducts(barcode: barcode);
      return Right(products);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryProductsEntity>> getCategoryProducts({int categoryId, int pageNumber}) async {
    try {
      CategoryProductsEntity products =
          await productsRemoteDataSource.getCategoryProducts(categoryId: categoryId, pageNumber: pageNumber);
      return Right(products);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryProductsEntity>> searchProducts({String query, int pageNumber}) async {
    try {
      CategoryProductsEntity products =
          await productsRemoteDataSource.searchProducts(query: query, pageNumber: pageNumber);
      return Right(products);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }
}

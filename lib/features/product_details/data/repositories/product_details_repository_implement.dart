import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/product_details_repository.dart';
import '../data_sources/products_details_remote_data_source.dart';

class ProductDetailsRepositoryImplement implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource productDetailsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  ProductDetailsRepositoryImplement({this.productDetailsRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> deleteProduct({int productId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => productDetailsRemoteDataSource.deleteProduct(productId: productId));
  }

  @override
  Future<Either<Failure, Unit>> deleteImage({int imageId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => productDetailsRemoteDataSource.deleteImage(imageId: imageId));
  }

  @override
  Future<Either<Failure, Unit>> removeProductFromCategory({String productId, String categoryId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            productDetailsRemoteDataSource.removeProductFromCategory(productId: productId, categoryId: categoryId));
  }
}

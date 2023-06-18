import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products_filter/data/data_sources/products_filter_remote_data_source.dart';
import 'package:kammun_app/features/products_filter/domain/entities/products_pagination_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/products_filter_repository.dart';

class ProductsFilterRepositoryImplement implements ProductsFilterRepository {
  final ProductsFilterRemoteDataSource productsFilterRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  ProductsFilterRepositoryImplement({this.productsFilterRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, ProductsPageEntity>> filterByNumberOfSales(
      {int numberOfSale, int page, int biggerThan}) async {
    try {
      ProductsPageEntity products = await productsFilterRemoteDataSource.filterByNumberOfSales(
          page: page, biggerThan: biggerThan, numberOfSale: numberOfSale);
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
  Future<Either<Failure, ProductsPageEntity>> filterByNumberOfVisits(
      {int numberOfVisit, int page, int biggerThan}) async {
    try {
      ProductsPageEntity products = await productsFilterRemoteDataSource.filterByNumberOfVisits(
          page: page, biggerThan: biggerThan, numberOfVisit: numberOfVisit);
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
  Future<Either<Failure, ProductsPageEntity>> getDeletedProductsFromOrders(
      {int page, String fromDate, String toDate}) async {
    try {
      ProductsPageEntity products = await productsFilterRemoteDataSource.getDeletedProductsFromOrders(
          page: page, fromDate: fromDate, toDate: toDate);
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
  Future<Either<Failure, ProductsPageEntity>> filterByLastActivationDate(
      {int numberOfDays, int page, int biggerThan}) async {
    try {
      ProductsPageEntity products = await productsFilterRemoteDataSource.filterByLastActivationDate(
          page: page, biggerThan: biggerThan, numberOfDays: numberOfDays);
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
}

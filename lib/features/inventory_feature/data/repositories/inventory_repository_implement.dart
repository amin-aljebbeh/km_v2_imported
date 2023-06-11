import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/inventory_feature/domain/repositories/inventory_repository.dart';
import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../data_sources/remote_inventory_data_source.dart';

class InventoryRepositoryImplement implements InventoryRepository {
  final RemoteInventoryDataSource remoteInventoryDataSource;
  final RepositoryFactory repositoryFactory;

  InventoryRepositoryImplement({this.remoteInventoryDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, FilteredProductsModel>> getNotificationProducts(
      {int pageNumber, int subWarehouseId, int isActive}) async {
    try {
      FilteredProductsModel products = await remoteInventoryDataSource.getNotificationProducts(
          pageNumber: pageNumber, isActive: isActive, subWarehouseId: subWarehouseId);
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
  Future<Either<Failure, FilteredProductsModel>> getPrimeProducts(
      {int pageNumber, int subWarehouseId, int isActive}) async {
    try {
      FilteredProductsModel products = await remoteInventoryDataSource.getPrimeProducts(
          pageNumber: pageNumber, isActive: isActive, subWarehouseId: subWarehouseId);
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
  Future<Either<Failure, List<ProductEntity>>> getUnderCheckAvailability({int subWarehouseId}) async {
    try {
      List<ProductEntity> products =
          await remoteInventoryDataSource.getUnderCheckAvailability(subWarehouseId: subWarehouseId);
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
  Future<Either<Failure, Unit>> targetInventory() async {
    return await repositoryFactory.failureUnitRepo(function: () => remoteInventoryDataSource.targetInventory());
  }

  @override
  Future<Either<Failure, Unit>> keepingAnInventoriesRecord() async {
    return await repositoryFactory.failureUnitRepo(
        function: () => remoteInventoryDataSource.keepingAnInventoriesRecord());
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      List<ProductEntity> products = await remoteInventoryDataSource.getAllProducts();
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
  Future<Either<Failure, List<ProductModel>>> getNotAddedProducts() async {
    try {
      List<ProductEntity> products = await remoteInventoryDataSource.getNotAddedProducts();
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
  Future<Either<Failure, List<ProductModel>>> getAddedProducts() async {
    try {
      List<ProductEntity> products = await remoteInventoryDataSource.getAddedProducts();
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

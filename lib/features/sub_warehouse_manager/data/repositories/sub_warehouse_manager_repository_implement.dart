import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/entities/inventory_file_product_entity.dart';
import 'package:kammun_app/features/sub_warehouse_manager/domain/entities/price_file_product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/sub_warehouse_manager_repository.dart';
import '../data_sources/sub_warehouse_local_data_source.dart';
import '../data_sources/sub_warehouse_remote_data_source.dart';

class SubWarehouseManagerRepositoryImplement implements SubWarehouseManagerRepository {
  final SubWarehouseManagerRemoteDataSource subWarehouseManagerRemoteDataSource;
  final SubWarehouseManagerLocalDataSource subWarehouseManagerLocaleDataSource;
  final RepositoryFactory repositoryFactory;

  SubWarehouseManagerRepositoryImplement(
      {this.repositoryFactory, this.subWarehouseManagerRemoteDataSource, this.subWarehouseManagerLocaleDataSource});

  @override
  Future<Either<Failure, InventoryFileProductEntity>> importProductActivationInWarehouse(
      {String subWarehouseId, File file}) async {
    try {
      InventoryFileProductEntity products = await subWarehouseManagerRemoteDataSource
          .importProductActivationInWarehouse(file: file, subWarehouseId: subWarehouseId);
      return Right(products);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } on InternalException catch (e) {
      return Left(InternalFailure(message: e.toString()));
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PriceFileProductEntity>> importProductPricesInWarehouse(
      {String subWarehouseId, File file}) async {
    try {
      PriceFileProductEntity products = await subWarehouseManagerRemoteDataSource.importProductPricesInWarehouse(
          file: file, subWarehouseId: subWarehouseId);
      return Right(products);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } on InternalException catch (e) {
      return Left(InternalFailure(message: e.toString()));
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePriceRateThreshold({String threshold}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => subWarehouseManagerRemoteDataSource.updatePriceRateThreshold(threshold: threshold));
  }

  @override
  Future<Either<Failure, File>> pickFile() async {
    try {
      File file = await subWarehouseManagerLocaleDataSource.pickFile();
      return Right(file);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } on InternalException catch (e) {
      return Left(InternalFailure(message: e.toString()));
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }
}

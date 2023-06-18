import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/excel_inventory/domain/entities/inventory_file_product_entity.dart';
import 'package:kammun_app/features/excel_inventory/domain/entities/price_file_product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/excel_inventory_repository.dart';
import '../data_sources/excel_inventory_remote_data_source.dart';

class ExcelInventoryRepositoryImplement implements ExcelInventoryRepository {
  final ExcelInventoryRemoteDataSource excelInventoryRemoteDataSource;

  ExcelInventoryRepositoryImplement({this.excelInventoryRemoteDataSource});

  @override
  Future<Either<Failure, InventoryFileProductEntity>> importProductActivationInWarehouse(
      {String subWarehouseId, File file}) async {
    try {
      InventoryFileProductEntity products = await excelInventoryRemoteDataSource.importProductActivationInWarehouse(
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
  Future<Either<Failure, PriceFileProductEntity>> importProductPricesInWarehouse(
      {String subWarehouseId, File file}) async {
    try {
      PriceFileProductEntity products = await excelInventoryRemoteDataSource.importProductPricesInWarehouse(
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
}

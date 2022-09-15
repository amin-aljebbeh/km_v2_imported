import 'package:dartz/dartz.dart';
import 'package:kammun_app/views/inventory_feature/domain/repositories/inventory_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import '../data_sources/remote_inventory_data_source.dart';

class InventoryRepositoryImplement implements InventoryRepository {
  final RemoteInventoryDataSource remoteInventoryDataSource;

  InventoryRepositoryImplement({this.remoteInventoryDataSource});
  @override
  Future<Either<Failure, FilteredProductsModel>> getNotificationProducts({int pageNumber}) async {
    try {
      FilteredProductsModel products = await remoteInventoryDataSource.getNotificationProducts(pageNumber: pageNumber);
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

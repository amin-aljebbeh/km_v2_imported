import 'package:dartz/dartz.dart';

import 'package:kammun_app/features/home/domain/entities/banner_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_inventory_data_source.dart';

class HomeRepositoryImplement implements HomeRepository {
  final HomeRemoteDataSource homeInventoryDataSource;
  final RepositoryFactory repositoryFactory;

  HomeRepositoryImplement({this.homeInventoryDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      List<BannerEntity> products = await homeInventoryDataSource.getBanners();
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

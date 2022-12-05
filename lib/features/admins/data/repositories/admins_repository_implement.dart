import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/data/data_sources/admins_remote_data_source.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/admins_repository.dart';

class AdminsRepositoryImplement implements AdminsRepository {
  final AdminsRemoteDataSource adminsRemoteDataSource;

  AdminsRepositoryImplement({this.adminsRemoteDataSource});
  @override
  Future<Either<Failure, List<AdminEntity>>> getAdmins() async {
    try {
      List<AdminEntity> admins = await adminsRemoteDataSource.getAdmins();
      return Right(admins);
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

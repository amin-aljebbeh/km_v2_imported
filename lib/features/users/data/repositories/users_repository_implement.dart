import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/users/data/data_sources/users_remote_data_source.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/users_repository.dart';

class UsersRepositoryImplement extends UsersRepository {
  final UsersRemoteDataSource usersRemoteDataSource;

  UsersRepositoryImplement({this.usersRemoteDataSource});
  @override
  Future<Either<Failure, Unit>> attachUserToCoupon({int couponId, int userId, int availability}) async {
    try {
      await usersRemoteDataSource.attachUserToCoupon(userId: userId, couponId: couponId, availability: availability);
      return const Right(unit);
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
  Future<Either<Failure, Unit>> depositUserWalletToCoupon({int userId, int value, String description}) async {
    try {
      await usersRemoteDataSource.depositUserWalletToCoupon(userId: userId, value: value, description: description);
      return const Right(unit);
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

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/users/data/data_sources/users_remote_data_source.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/users_repository.dart';

class UsersRepositoryImplement extends UsersRepository {
  final UsersRemoteDataSource usersRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  UsersRepositoryImplement({this.usersRemoteDataSource, this.repositoryFactory});
  @override
  Future<Either<Failure, Unit>> attachUserToCoupon({int couponId, int userId, int availability}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            usersRemoteDataSource.attachUserToCoupon(userId: userId, couponId: couponId, availability: availability));
  }

  @override
  Future<Either<Failure, Unit>> changeNumberPhoneUser({int userId, String phoneNumber}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => usersRemoteDataSource.changeNumberPhoneUser(userId: userId, phoneNumber: phoneNumber));
  }
}

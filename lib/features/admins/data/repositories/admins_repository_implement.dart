import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/data/data_sources/admins_remote_data_source.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';
import 'package:kammun_app/features/authentication/domain/entities/login_admin_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/admins_repository.dart';

class AdminsRepositoryImplement implements AdminsRepository {
  final AdminsRemoteDataSource adminsRemoteDataSource;

  AdminsRepositoryImplement({this.adminsRemoteDataSource});

  @override
  Future<Either<Failure, List<AdminEntity>>> getAdminsWithoutDetails(
      {int roleId, int warehouseId, String searchName}) async {
    try {
      List<AdminEntity> admins = await adminsRemoteDataSource.getAdminsWithoutDetails(
          roleId: roleId, warehouseId: warehouseId, searchName: searchName);
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

  @override
  Future<Either<Failure, List<AdminEntity>>> getTransactionsActors({int categoryId}) async {
    try {
      List<AdminEntity> admins = await adminsRemoteDataSource.getTransactionsActors(categoryId: categoryId);
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

  @override
  Future<Either<Failure, List<RoleEntity>>> getRoles() async {
    try {
      List<RoleEntity> roles = await adminsRemoteDataSource.getRoles();
      return Right(roles);
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
  Future<Either<Failure, AdminLoginResponseEntity>> getAdmin({int adminId}) async {
    try {
      AdminLoginResponseEntity admin = await adminsRemoteDataSource.getAdmin(adminId: adminId);
      return Right(admin);
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

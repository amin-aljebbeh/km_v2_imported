import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';
import 'package:kammun_app/features/admins/domain/entities/role_entity.dart';

import '../../../authentication/domain/entities/login_admin_entity.dart';
import '../entities/create_admin_entity.dart';

abstract class AdminsRepository {
  Future<Either<Failure, List<AdminEntity>>> getAdminsWithoutDetails({int roleId, int warehouseId, String searchName});
  Future<Either<Failure, List<AdminEntity>>> getTransactionsActors({int categoryId});
  Future<Either<Failure, List<RoleEntity>>> getRoles();
  Future<Either<Failure, AdminLoginResponseEntity>> getAdmin({int adminId});
  Future<Either<Failure, Unit>> createAdmin({CreateAdminEntity admin});
}

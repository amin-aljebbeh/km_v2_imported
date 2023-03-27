import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/repositories/admins_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/role_entity.dart';

class GetRolesUseCase {
  final AdminsRepository adminsRepository;

  GetRolesUseCase({this.adminsRepository});

  Future<Either<Failure, List<RoleEntity>>> call() async {
    return await adminsRepository.getRoles();
  }
}

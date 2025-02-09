import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/entities/create_admin_entity.dart';
import 'package:kammun_app/features/admins/domain/repositories/admins_repository.dart';

import '../../../../core/core_importer.dart';

class CreateAdminUseCase {
  final AdminsRepository adminsRepository;

  CreateAdminUseCase({this.adminsRepository});

  Future<Either<Failure, Unit>> call({CreateAdminEntity admin}) async {
    return await adminsRepository.createAdmin(admin: admin);
  }
}

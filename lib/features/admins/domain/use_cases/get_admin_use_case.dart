import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/repositories/admins_repository.dart';

import '../../../../core/core_importer.dart';
import '../../../authentication/domain/entities/login_admin_entity.dart';

class GetAdminUseCase {
  final AdminsRepository adminsRepository;

  GetAdminUseCase({this.adminsRepository});

  Future<Either<Failure, AdminLoginResponseEntity>> call({int adminId}) async {
    return await adminsRepository.getAdmin(adminId: adminId);
  }
}

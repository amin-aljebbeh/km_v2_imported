import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/repositories/admins_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/admins_entity.dart';

class GetAdminsWithoutDetailsUseCase {
  final AdminsRepository adminsRepository;

  GetAdminsWithoutDetailsUseCase({this.adminsRepository});

  Future<Either<Failure, List<AdminEntity>>> call({int roleId, int warehouseId, String searchName}) async {
    return await adminsRepository.getAdminsWithoutDetails(
        searchName: searchName, warehouseId: warehouseId, roleId: roleId);
  }
}

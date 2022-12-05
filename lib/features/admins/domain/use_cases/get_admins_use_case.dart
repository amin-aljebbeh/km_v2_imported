import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/repositories/admins_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/admins_entity.dart';

class GetAdminsUseCase {
  final AdminsRepository adminsRepository;

  GetAdminsUseCase({this.adminsRepository});

  Future<Either<Failure, List<AdminEntity>>> call() async {
    return await adminsRepository.getAdmins();
  }
}

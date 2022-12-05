import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/admins/domain/entities/admins_entity.dart';

abstract class AdminsRepository {
  Future<Either<Failure, List<AdminEntity>>> getAdmins();
}

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/admins/domain/repositories/admins_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/admins_entity.dart';

class GetTransactionsActorsUseCase {
  final AdminsRepository adminsRepository;

  GetTransactionsActorsUseCase({this.adminsRepository});

  Future<Either<Failure, List<AdminEntity>>> call({int categoryId}) async {
    return await adminsRepository.getTransactionsActors(categoryId: categoryId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/entities/admin_balance_entity.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';

class GetAdminBalanceUseCase {
  final TransactionsRepository transactionsRepository;

  GetAdminBalanceUseCase({this.transactionsRepository});

  Future<Either<Failure, AdminBalanceEntity>> call({int adminId}) async {
    return await transactionsRepository.getAdminBalance(adminId: adminId);
  }
}

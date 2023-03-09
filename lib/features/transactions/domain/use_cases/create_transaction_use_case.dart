import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/admin_transaction_entity.dart';

class CreateTransactionUseCase {
  final TransactionsRepository transactionsRepository;

  CreateTransactionUseCase({this.transactionsRepository});

  Future<Either<Failure, Unit>> call({AdminTransactionEntity transactionEntity}) async {
    return await transactionsRepository.createTransaction(transactionEntity: transactionEntity);
  }
}

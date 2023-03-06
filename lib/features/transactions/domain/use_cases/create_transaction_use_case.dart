import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/transaction_entity.dart';

class CreateTransactionUseCase {
  final TransactionsRepository transactionsRepository;

  CreateTransactionUseCase({this.transactionsRepository});

  Future<Either<Failure, Unit>> call({TransactionEntity transactionEntity}) async {
    return await transactionsRepository.createTransaction(transactionEntity: transactionEntity);
  }
}

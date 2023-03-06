import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/transaction_entity.dart';

class GetTransactionsUseCase {
  final TransactionsRepository transactionsRepository;

  GetTransactionsUseCase({this.transactionsRepository});

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await transactionsRepository.getTransactions();
  }
}

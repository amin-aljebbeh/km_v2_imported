import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/transaction_request_entity.dart';

class UpdateTransactionRequestUseCase {
  final TransactionsRepository transactionsRepository;

  UpdateTransactionRequestUseCase({this.transactionsRepository});

  Future<Either<Failure, Unit>> call({TransactionRequestEntity transactionRequestEntity}) async {
    return await transactionsRepository.updateTransactionRequest(transactionRequestEntity: transactionRequestEntity);
  }
}

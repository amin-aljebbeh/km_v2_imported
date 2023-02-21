import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/transaction_request_entity.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<TransactionRequestEntity>>> getTransactionRequests();
  Future<Either<Failure, Unit>> updateTransactionRequest({TransactionRequestEntity transactionRequestEntity});
  Future<Either<Failure, Unit>> deleteTransactionRequest({TransactionRequestEntity transactionRequestEntity});
  Future<Either<Failure, Unit>> createTransactionRequest({TransactionRequestEntity transactionRequestEntity});
}

import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/admin_transaction_entity.dart';
import '../entities/transaction_category_entity.dart';
import '../entities/transaction_requests_response_entity.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<TransactionCategoryEntity>>> getTransactionCategories();

  Future<Either<Failure, RequestsDataEntity>> getTransactionRequests(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber});

  Future<Either<Failure, List<AdminTransactionEntity>>> getTransactions(
      {int pageNumber, int adminId, int lastWeek, int groupingByParent});

  Future<Either<Failure, Unit>> changeTransactionRequestStatus({int requestId, int statusId, String rejectReason});

  Future<Either<Failure, Unit>> deleteTransactionRequest({int requestId});

  Future<Either<Failure, Unit>> createTransaction({AdminTransactionEntity transactionEntity});
}

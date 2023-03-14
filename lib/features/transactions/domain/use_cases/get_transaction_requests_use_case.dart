import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/transaction_request_entity.dart';

class GetTransactionRequestsUseCase {
  final TransactionsRepository transactionsRepository;

  GetTransactionRequestsUseCase({this.transactionsRepository});

  Future<Either<Failure, List<TransactionRequestEntity>>> call(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber}) async {
    return await transactionsRepository.getTransactionRequests(
        transactionStatusId: transactionStatusId,
        createdByMe: createdByMe,
        assignedToMe: assignedToMe,
        pageNumber: pageNumber,
        transactionCategoryId: transactionCategoryId);
  }
}

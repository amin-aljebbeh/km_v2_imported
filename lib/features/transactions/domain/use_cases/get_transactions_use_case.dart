import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/admin_transaction_entity.dart';

class GetTransactionsUseCase {
  final TransactionsRepository transactionsRepository;

  GetTransactionsUseCase({this.transactionsRepository});

  Future<Either<Failure, List<AdminTransactionEntity>>> call({int pageNumber}) async {
    return await transactionsRepository.getTransactions(pageNumber: pageNumber);
  }
}

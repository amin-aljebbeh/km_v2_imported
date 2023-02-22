import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';

class GetTransactionCategoriesUseCase {
  final TransactionsRepository transactionsRepository;

  GetTransactionCategoriesUseCase({this.transactionsRepository});

  Future<Either<Failure, List<TransactionCategoryEntity>>> call() async {
    return await transactionsRepository.getTransactionCategories();
  }
}

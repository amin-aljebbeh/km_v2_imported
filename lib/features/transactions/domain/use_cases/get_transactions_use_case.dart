import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/transactions_response_entity.dart';

class GetTransactionsUseCase {
  final TransactionsRepository transactionsRepository;

  GetTransactionsUseCase({this.transactionsRepository});

  Future<Either<Failure, TransactionsPaginationEntity>> call(
      {int pageNumber, int adminId, int lastWeek, int groupingByParent}) async {
    return await transactionsRepository.getTransactions(
        pageNumber: pageNumber, lastWeek: lastWeek, groupingByParent: groupingByParent, adminId: adminId);
  }
}

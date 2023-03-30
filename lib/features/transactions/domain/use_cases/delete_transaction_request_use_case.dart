import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';

class DeleteTransactionRequestUseCase {
  final TransactionsRepository transactionsRepository;

  DeleteTransactionRequestUseCase({this.transactionsRepository});

  Future<Either<Failure, Unit>> call({int requestId}) async {
    return await transactionsRepository.deleteTransactionRequest(requestId: requestId);
  }
}

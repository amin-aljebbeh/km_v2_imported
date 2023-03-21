import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/repositories/transactions_repository.dart';

import '../../../../core/core_importer.dart';

class ChangeTransactionRequestStatusUseCase {
  final TransactionsRepository transactionsRepository;

  ChangeTransactionRequestStatusUseCase({this.transactionsRepository});

  Future<Either<Failure, Unit>> call({int requestId, int statusId, String rejectReason}) async {
    return await transactionsRepository.changeTransactionRequestStatus(
        statusId: statusId, requestId: requestId, rejectReason: rejectReason);
  }
}

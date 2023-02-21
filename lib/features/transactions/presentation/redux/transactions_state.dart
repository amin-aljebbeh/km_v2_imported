import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_request_entity.dart';
import '../../domain/use_cases/transactions_use_cases.dart';

@immutable
class TransactionsState extends Equatable {
  final TransactionsUseCase transactionsUseCase;
  final List<TransactionRequestEntity> requests;
  final int requestPage;
  final bool hasNextRequests;
  const TransactionsState({this.requestPage, this.transactionsUseCase, this.requests, this.hasNextRequests});

  factory TransactionsState.initial() {
    return TransactionsState(
        requests: const [], transactionsUseCase: sl<TransactionsUseCase>(), requestPage: 1, hasNextRequests: true);
  }

  TransactionsState copyWith({List<TransactionRequestEntity> requests, int requestPage, bool hasNextRequests}) {
    return TransactionsState(
      requests: requests ?? this.requests,
      transactionsUseCase: transactionsUseCase,
      hasNextRequests: hasNextRequests ?? this.hasNextRequests,
      requestPage: requestPage ?? this.requestPage,
    );
  }

  @override
  List<Object> get props => [transactionsUseCase];
}

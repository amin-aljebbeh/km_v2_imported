import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transaction_request_entity.dart';
import '../../domain/use_cases/transactions_use_cases.dart';

@immutable
class TransactionsState extends Equatable {
  final TransactionsUseCase transactionsUseCase;
  final List<TransactionRequestEntity> requests;
  final List<AdminTransactionEntity> transactions;
  final List<TransactionCategoryEntity> categories;
  final int requestPage;
  final bool hasNextRequests;

  const TransactionsState({
    this.requestPage,
    this.transactionsUseCase,
    this.requests,
    this.hasNextRequests,
    this.categories,
    this.transactions,
  });

  factory TransactionsState.initial() {
    return TransactionsState(
      requests: const [],
      transactionsUseCase: sl<TransactionsUseCase>(),
      requestPage: 1,
      hasNextRequests: true,
      categories: const [],
      transactions: const [],
    );
  }

  TransactionsState copyWith({
    List<TransactionRequestEntity> requests,
    int requestPage,
    bool hasNextRequests,
    List<TransactionCategoryEntity> categories,
    List<AdminTransactionEntity> transactions,
  }) {
    return TransactionsState(
      requests: requests ?? this.requests,
      transactionsUseCase: transactionsUseCase,
      hasNextRequests: hasNextRequests ?? this.hasNextRequests,
      requestPage: requestPage ?? this.requestPage,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object> get props => [transactionsUseCase, requests, categories, requestPage, hasNextRequests, transactions];
}

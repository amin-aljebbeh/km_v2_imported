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
  final int requestsPage;
  final bool hasNextRequests;
  final int transactionsPage;
  final bool hasNextTransactions;
  final int assignedToMe;
  final int createdByMe;
  final int transactionStatusId;
  final int transactionCategoryId;

  const TransactionsState({
    this.assignedToMe,
    this.createdByMe,
    this.transactionStatusId,
    this.transactionCategoryId,
    this.transactionsPage,
    this.hasNextTransactions,
    this.requestsPage,
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
      requestsPage: 1,
      hasNextRequests: true,
      categories: const [],
      transactions: const [],
      hasNextTransactions: true,
      transactionsPage: 1,
      assignedToMe: 0,
      createdByMe: 0,
      transactionCategoryId: null,
      transactionStatusId: null,
    );
  }

  TransactionsState copyWith({
    List<TransactionRequestEntity> requests,
    int requestsPage,
    bool hasNextRequests,
    List<TransactionCategoryEntity> categories,
    List<AdminTransactionEntity> transactions,
    int transactionsPage,
    bool hasNextTransactions,
    int assignedToMe,
    int createdByMe,
    int transactionStatusId,
    int transactionCategoryId,
  }) {
    return TransactionsState(
      requests: requests ?? this.requests,
      transactionsUseCase: transactionsUseCase,
      hasNextRequests: hasNextRequests ?? this.hasNextRequests,
      requestsPage: requestsPage ?? this.requestsPage,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      transactionsPage: transactionsPage ?? this.transactionsPage,
      hasNextTransactions: hasNextTransactions ?? this.hasNextTransactions,
      assignedToMe: assignedToMe ?? this.assignedToMe,
      createdByMe: createdByMe ?? this.createdByMe,
      transactionStatusId: transactionStatusId == -1 ? null : transactionStatusId ?? this.transactionStatusId,
      transactionCategoryId: transactionCategoryId == -1 ? null : transactionCategoryId ?? this.transactionCategoryId,
    );
  }

  @override
  List<Object> get props => [
        transactionsUseCase,
        requests,
        categories,
        requestsPage,
        hasNextRequests,
        transactions,
        transactionsPage,
        hasNextTransactions,
        assignedToMe,
        createdByMe,
        transactionStatusId,
        transactionCategoryId,
      ];
}

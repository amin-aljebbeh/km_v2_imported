import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_request_entity.dart';
import '../../domain/use_cases/transactions_use_cases.dart';

@immutable
class TransactionsState extends Equatable {
  final TransactionsUseCase transactionsUseCase;
  final List<TransactionRequestEntity> requests;
  final List<TransactionCategoryEntity> categories;
  final int requestPage;
  final bool hasNextRequests;
  const TransactionsState(
      {this.requestPage, this.transactionsUseCase, this.requests, this.hasNextRequests, this.categories});

  factory TransactionsState.initial() {
    return TransactionsState(
      requests: const [],
      transactionsUseCase: sl<TransactionsUseCase>(),
      requestPage: 1,
      hasNextRequests: true,
      categories: const [],
    );
  }

  TransactionsState copyWith({
    List<TransactionRequestEntity> requests,
    int requestPage,
    bool hasNextRequests,
    List<TransactionCategoryEntity> categories,
  }) {
    return TransactionsState(
      requests: requests ?? this.requests,
      transactionsUseCase: transactionsUseCase,
      hasNextRequests: hasNextRequests ?? this.hasNextRequests,
      requestPage: requestPage ?? this.requestPage,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [transactionsUseCase, requests, categories, requestPage, hasNextRequests];
}

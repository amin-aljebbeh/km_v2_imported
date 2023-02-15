import '../../../../core/core_importer.dart';
import '../../domain/use_cases/transactions_use_cases.dart';

@immutable
class TransactionsState extends Equatable {
  final TransactionsUseCase transactionsUseCase;
  const TransactionsState({this.transactionsUseCase});

  factory TransactionsState.initial() {
    return TransactionsState(transactionsUseCase: sl<TransactionsUseCase>());
  }

  TransactionsState copyWith() {
    return TransactionsState(transactionsUseCase: transactionsUseCase);
  }

  @override
  List<Object> get props => [transactionsUseCase];
}

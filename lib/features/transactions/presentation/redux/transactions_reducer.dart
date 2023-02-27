import '../../../../core/core_importer.dart';
import 'transactions_action.dart';
import 'transactions_state.dart';

Reducer<TransactionsState> transactionsReducer = combineReducers<TransactionsState>([
  TypedReducer<TransactionsState, SetTransactionRequests>(setTransactionRequests),
  TypedReducer<TransactionsState, SetTransactionCategories>(setTransactionCategories),
  TypedReducer<TransactionsState, NextTransactionRequestsPage>(nextTransactionRequestsPage),
  TypedReducer<TransactionsState, EndOfTransactionsRequests>(endOfTransactionsRequests),
  TypedReducer<TransactionsState, FirstPage>(firstPage),
]);

TransactionsState setTransactionRequests(TransactionsState state, SetTransactionRequests action) {
  return state.copyWith(requests: action.requests);
}

TransactionsState nextTransactionRequestsPage(TransactionsState state, NextTransactionRequestsPage action) =>
    state.copyWith(requestPage: state.requestPage + 1);

TransactionsState endOfTransactionsRequests(TransactionsState state, EndOfTransactionsRequests action) =>
    state.copyWith(hasNextRequests: false);

TransactionsState firstPage(TransactionsState state, FirstPage action) =>
    state.copyWith(hasNextRequests: true, requestPage: 1);

TransactionsState setTransactionCategories(TransactionsState state, SetTransactionCategories action) =>
    state.copyWith(categories: action.categories);

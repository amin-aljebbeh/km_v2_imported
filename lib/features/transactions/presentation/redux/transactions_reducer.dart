import '../../../../core/core_importer.dart';
import 'transactions_action.dart';
import 'transactions_state.dart';

Reducer<TransactionsState> transactionsReducer = combineReducers<TransactionsState>([
  TypedReducer<TransactionsState, SetTransactionRequests>(setTransactionRequests),
  TypedReducer<TransactionsState, SetTransactionCategories>(setTransactionCategories),
  TypedReducer<TransactionsState, NextTransactionRequestsPage>(nextTransactionRequestsPage),
  TypedReducer<TransactionsState, NextTransactionsPage>(nextTransactionsPage),
  TypedReducer<TransactionsState, EndOfTransactionsRequests>(endOfTransactionsRequests),
  TypedReducer<TransactionsState, EndOfTransactions>(endOfTransactions),
  TypedReducer<TransactionsState, SetTransactions>(setTransactions),
  TypedReducer<TransactionsState, FirstRequestsPage>(firstRequestsPage),
  TypedReducer<TransactionsState, FirstTransactionsPage>(firstTransactionsPage),
]);

TransactionsState setTransactionRequests(TransactionsState state, SetTransactionRequests action) {
  return state.copyWith(requests: action.requests);
}

TransactionsState nextTransactionRequestsPage(TransactionsState state, NextTransactionRequestsPage action) =>
    state.copyWith(requestsPage: state.requestsPage + 1);

TransactionsState endOfTransactionsRequests(TransactionsState state, EndOfTransactionsRequests action) =>
    state.copyWith(hasNextRequests: false);

TransactionsState firstRequestsPage(TransactionsState state, FirstRequestsPage action) =>
    state.copyWith(hasNextRequests: true, requestsPage: 1, requests: []);

TransactionsState setTransactionCategories(TransactionsState state, SetTransactionCategories action) =>
    state.copyWith(categories: action.categories);

TransactionsState setTransactions(TransactionsState state, SetTransactions action) =>
    state.copyWith(transactions: action.transactions);

TransactionsState firstTransactionsPage(TransactionsState state, FirstTransactionsPage action) =>
    state.copyWith(hasNextTransactions: true, transactionsPage: 1, transactions: []);

TransactionsState endOfTransactions(TransactionsState state, EndOfTransactions action) =>
    state.copyWith(hasNextTransactions: false);

TransactionsState nextTransactionsPage(TransactionsState state, NextTransactionsPage action) =>
    state.copyWith(transactionsPage: state.transactionsPage + 1);

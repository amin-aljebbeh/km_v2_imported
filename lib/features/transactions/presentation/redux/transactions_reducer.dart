import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_request_entity.dart';
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
  TypedReducer<TransactionsState, ClearTransactionRequests>(clearTransactionRequests),
  TypedReducer<TransactionsState, SetTransactionStatusId>(setTransactionStatusId),
  TypedReducer<TransactionsState, SetTransactionCategoryId>(setTransactionCategoryId),
  TypedReducer<TransactionsState, SetCreatedByMe>(setCreatedByMe),
  TypedReducer<TransactionsState, SetAssignedToMe>(setAssignedToMe),
]);

TransactionsState setTransactionRequests(TransactionsState state, SetTransactionRequests action) {
  List<TransactionRequestEntity> requests = [];
  requests.addAll(requests);
  requests.addAll(action.requests);
  return state.copyWith(requests: requests);
}

TransactionsState clearTransactionRequests(TransactionsState state, ClearTransactionRequests action) {
  return state.copyWith(requests: []);
}

TransactionsState nextTransactionRequestsPage(TransactionsState state, NextTransactionRequestsPage action) =>
    state.copyWith(requestsPage: state.requestsPage + 1);

TransactionsState endOfTransactionsRequests(TransactionsState state, EndOfTransactionsRequests action) =>
    state.copyWith(hasNextRequests: false);

TransactionsState firstRequestsPage(TransactionsState state, FirstRequestsPage action) => state.copyWith(
      hasNextRequests: true,
      requestsPage: 1,
      requests: [],
      transactionStatusId: -1,
      transactionCategoryId: -1,
      createdByMe: 0,
      assignedToMe: 0,
    );

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

TransactionsState setTransactionStatusId(TransactionsState state, SetTransactionStatusId action) =>
    state.copyWith(transactionStatusId: action.transactionStatusId);

TransactionsState setTransactionCategoryId(TransactionsState state, SetTransactionCategoryId action) =>
    state.copyWith(transactionCategoryId: action.transactionCategoryId);

TransactionsState setCreatedByMe(TransactionsState state, SetCreatedByMe action) =>
    state.copyWith(createdByMe: action.createdByMe);

TransactionsState setAssignedToMe(TransactionsState state, SetAssignedToMe action) =>
    state.copyWith(assignedToMe: action.assignedToMe);

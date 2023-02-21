import '../../../../core/core_importer.dart';
import 'transactions_action.dart';
import 'transactions_state.dart';

Reducer<TransactionsState> transactionsReducer = combineReducers<TransactionsState>(
    [TypedReducer<TransactionsState, SetTransactionRequests>(setTransactionRequests)]);

TransactionsState setTransactionRequests(TransactionsState state, SetTransactionRequests action) =>
    state.copyWith(requests: action.requests);

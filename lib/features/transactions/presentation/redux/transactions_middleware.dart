import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';

Future<void> transactionsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is CreateTransactionAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .createTransactionUseCase(transactionEntity: action.transactionEntity);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      snackBar(success: true, context: action.context, message: 'تمت العملية بنجاح');
      if (action.pop) Navigator.pop(action.context);
    });
    store.dispatch(StopLoading());
  } else if (action is UpdateTransactionRequestAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .updateTransactionRequestUseCase(transactionRequestEntity: action.transactionRequestEntity);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => store.dispatch(ViewMessage(message: 'تمت العملية بنجاح')));
    store.dispatch(StopLoading());
  } else if (action is DeleteTransactionRequestAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .deleteTransactionRequestUseCase(transactionRequestEntity: action.transactionRequestEntity);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => store.dispatch(ViewMessage(message: 'تمت العملية بنجاح')));
    store.dispatch(StopLoading());
  } else if (action is GetTransactionRequestsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionRequestsUseCase(
        transactionCategoryId: action.transactionCategoryId,
        assignedToMe: action.assignedToMe,
        createdByMe: action.createdByMe,
        pageNumber: store.state.transactionsState.requestsPage,
        transactionStatusId: action.transactionStatusId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (requests) => store.dispatch(SetTransactionRequests(requests: requests)));
    store.dispatch(StopLoading());
  } else if (action is GetTransactionsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .getTransactionsUseCase(pageNumber: store.state.transactionsState.transactionsPage);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (transactions) => store.dispatch(SetTransactions(transactions: transactions)));
    store.dispatch(StopLoading());
  } else if (action is GetTransactionCategoriesAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionCategoriesUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (categories) => store.dispatch(SetTransactionCategories(categories: categories)));
    store.dispatch(StopLoading());
  }
  next(action);
}

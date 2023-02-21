import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';

Future<void> transactionsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is CreateTransactionRequestAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .createTransactionRequestUseCase(transactionRequestEntity: action.transactionRequestEntity);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (_) => store.dispatch(ViewMessage(message: 'تمت العملية بنجاح')));
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
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionRequestsUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (requests) => store.dispatch(SetTransactionRequests(requests: requests)));
    store.dispatch(StopLoading());
  }

  next(action);
}

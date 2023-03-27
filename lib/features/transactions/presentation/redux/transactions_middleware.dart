import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_requests_response_entity.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_balance_entity.dart';
import '../widgets/admin_balance_widget.dart';

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
  } else if (action is ChangeTransactionRequestStatusAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.changeTransactionRequestStatusUseCase(
        statusId: action.statusId, requestId: action.requestId, rejectReason: action.rejectReason);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      store.dispatch(TransactionRequestChanged(
          rejectReason: action.rejectReason, requestId: action.requestId, statusId: action.statusId));
      store.dispatch(ViewMessage(message: 'تمت العملية بنجاح'));
    });
    store.dispatch(StopLoading());
  } else if (action is DeleteTransactionRequestAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .deleteTransactionRequestUseCase(requestId: action.requestId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      store.dispatch(RequestDeleted(requestId: action.requestId));
      store.dispatch(ViewMessage(message: 'تمت العملية بنجاح'));
    });
    store.dispatch(StopLoading());
  } else if (action is GetTransactionRequestsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionRequestsUseCase(
      transactionCategoryId: store.state.transactionsState.transactionCategoryId,
      assignedToMe: store.state.transactionsState.assignedToMe,
      createdByMe: store.state.transactionsState.createdByMe,
      transactionStatusId: store.state.transactionsState.transactionStatusId,
      pageNumber: store.state.transactionsState.requestsPage,
    );
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (requests) {
      RequestsDataEntity req = requests;
      store.dispatch(SetFilterCategories(categories: req.categoryForFilter));
      if (req.transactionRequest.currentPage == req.transactionRequest.lastPage) {
        store.dispatch(EndOfTransactionsRequests());
      }
      store.dispatch(SetTransactionRequests(requests: req.transactionRequest.requests));
    });
    store.dispatch(StopLoading());
  } else if (action is GetTransactionsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionsUseCase(
      pageNumber: store.state.transactionsState.transactionsPage,
      adminId: store.state.adminsState.admin.permissions.contains('advanced-transaction-view') ? action.adminId : null,
      groupingByParent:
          store.state.adminsState.admin.permissions.contains('advanced-transaction-view') ? action.groupingByParent : 0,
      lastWeek: store.state.adminsState.admin.permissions.contains('advanced-transaction-view') ? 1 : 0,
    );
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (transactions) => store.dispatch(SetTransactions(transactions: transactions)));
    store.dispatch(StopLoading());
  } else if (action is GetTransactionCategoriesAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionCategoriesUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (categories) => store.dispatch(SetTransactionCategories(categories: categories)));
    store.dispatch(StopLoading());
  } else if (action is GetShopperReportAction) {
    Either either =
        await store.state.transactionsState.transactionsUseCase.getShopperReportUseCase(shopperId: action.shopperId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (shopperReport) => store.dispatch(SetShopperReport(shopperReport: shopperReport)));
  } else if (action is GetAdminBalanceAction) {
    store.dispatch(StartLoading());
    Either either =
        await store.state.transactionsState.transactionsUseCase.getAdminBalanceUseCase(adminId: action.adminId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (shopperReport) {
      AdminBalanceEntity balance = shopperReport;
      adminBalanceWidget(context: action.context, balance: balance);
    });
    store.dispatch(StopLoading());
  }
  next(action);
}

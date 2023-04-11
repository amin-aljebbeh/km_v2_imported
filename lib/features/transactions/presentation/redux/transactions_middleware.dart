import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_requests_response_entity.dart';
import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_balance_entity.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transactions_response_entity.dart';
import '../widgets/admin_balance_widget.dart';
import '../widgets/specific_day_profit_widget.dart';

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
      snackBar(message: 'تمت العملية بنجاح', success: true, context: action.context);
    });
    store.dispatch(StopLoading());
  } else if (action is DeleteTransactionRequestAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .deleteTransactionRequestUseCase(requestId: action.requestId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      store.dispatch(RequestDeleted(requestId: action.requestId));
      snackBar(message: 'تمت العملية بنجاح', success: true, context: action.context);
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
      adminId:
          store.state.adminsState.admin.permissions.contains(advancedTransactionPermission) ? action.adminId : null,
      groupingByParent: store.state.adminsState.admin.permissions.contains(advancedTransactionPermission)
          ? store.state.transactionsState.groupingTransactions
              ? 1
              : 0
          : 1,
      lastWeek: store.state.adminsState.admin.permissions.contains(advancedTransactionPermission) ? 0 : 1,
    );
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (transactionsPage) {
      TransactionsPaginationEntity transactions = transactionsPage;
      if (transactions.currentPage == transactions.lastPage) {
        store.dispatch(EndOfTransactions());
      }
      store.dispatch(SetTransactions(transactions: transactionsPage.transactions));
    });
    store.dispatch(StopLoading());
  } else if (action is GetTransactionCategoriesAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionCategoriesUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (categories) => store.dispatch(SetTransactionCategories(categories: categories)));
    store.dispatch(StopLoading());
  } else if (action is GetShopperReportAction) {
    store.dispatch(StartLoading());
    Either either =
        await store.state.transactionsState.transactionsUseCase.getShopperReportUseCase(shopperId: action.shopperId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (shopperReport) => store.dispatch(SetShopperReport(shopperReport: shopperReport)));
    store.dispatch(StopLoading());
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
  } else if (action is ParticularDayProfits) {
    List<AdminTransactionEntity> transactions = [];
    bool error = false;
    bool toBreak = false;
    Either either;
    int beforeNumber = store.state.transactionsState.transactionsPage;
    int afterNumber = store.state.transactionsState.transactionsPage;
    int length;
    store.dispatch(StartLoading());
    either = await store.state.transactionsState.transactionsUseCase.getTransactionsUseCase(
      pageNumber: store.state.transactionsState.transactionsPage,
      adminId: action.adminId,
      groupingByParent: Services.hasPermission(action.context, advancedTransactionPermission)
          ? store.state.transactionsState.groupingTransactions
              ? 1
              : 0
          : 1,
      lastWeek: Services.hasPermission(action.context, advancedTransactionPermission) ? 0 : 1,
    );
    either.fold((failure) => error = true, (transactionsPage) {
      TransactionsPaginationEntity tempTransactions = transactionsPage;
      transactions
          .addAll(tempTransactions.transactions.where((transaction) => transaction.createdAt.day == action.date.day));
    });
    while (beforeNumber > 1) {
      length = transactions.length;
      either = await store.state.transactionsState.transactionsUseCase.getTransactionsUseCase(
          pageNumber: beforeNumber - 1,
          adminId: action.adminId,
          groupingByParent: Services.hasPermission(action.context, advancedTransactionPermission)
              ? store.state.transactionsState.groupingTransactions
                  ? 1
                  : 0
              : 1,
          lastWeek: Services.hasPermission(action.context, advancedTransactionPermission) ? 0 : 1);
      either.fold((failure) => error = true, (transactionsPage) {
        TransactionsPaginationEntity tempTransactions = transactionsPage;
        transactions
            .addAll(tempTransactions.transactions.where((transaction) => transaction.createdAt.day == action.date.day));

        if ((length == transactions.length) ||
            (transactions.length - length < tempTransactions.perPage && length != transactions.length)) {
          toBreak = true;
        }
      });
      if (length == transactions.length || toBreak) break;
      beforeNumber--;
    }
    while (!error) {
      toBreak = false;
      length = transactions.length;
      either = await store.state.transactionsState.transactionsUseCase.getTransactionsUseCase(
          pageNumber: afterNumber + 1,
          adminId: action.adminId,
          groupingByParent: Services.hasPermission(action.context, advancedTransactionPermission)
              ? store.state.transactionsState.groupingTransactions
                  ? 1
                  : 0
              : 1,
          lastWeek: Services.hasPermission(action.context, advancedTransactionPermission) ? 0 : 1);
      either.fold((failure) => error = true, (transactionsPage) {
        TransactionsPaginationEntity tempTransactions = transactionsPage;
        transactions
            .addAll(tempTransactions.transactions.where((transaction) => transaction.createdAt.day == action.date.day));
        if ((length == transactions.length) ||
            (transactions.length - length < tempTransactions.perPage && length != transactions.length) ||
            (tempTransactions.lastPage == tempTransactions.currentPage)) {
          toBreak = true;
        }
      });
      if (length == transactions.length || toBreak) break;
      afterNumber++;
    }
    store.dispatch(StopLoading());
    if (error) {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً'));
    } else {
      specificDayProfitWidget(context: action.context, date: action.date, transactions: transactions);
    }
  }
  next(action);
}

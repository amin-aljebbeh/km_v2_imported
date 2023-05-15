import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_balance_entity.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/shopper_report_entity.dart';
import '../../domain/entities/transaction_request_entity.dart';
import '../../domain/entities/transaction_requests_response_entity.dart';
import '../../domain/entities/transactions_response_entity.dart';
import '../widgets/admin_balance_widget.dart';
import '../widgets/specific_day_profit_widget.dart';

abstract class TransactionsAction {
  handle({@required Store<AppState> store});
}

class CreateTransactionAction implements TransactionsAction {
  final bool pop;
  final BuildContext context;
  final AdminTransactionEntity transactionEntity;

  CreateTransactionAction({this.transactionEntity, this.context, this.pop = true});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .createTransactionUseCase(transactionEntity: transactionEntity);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      snackBar(success: true, context: context, message: 'تمت العملية بنجاح');
      if (pop) Navigator.pop(context);
    });
    store.dispatch(StopLoading());
  }
}

class DeleteTransactionRequestAction implements TransactionsAction {
  final int requestId;
  final BuildContext context;

  DeleteTransactionRequestAction({this.requestId, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.transactionsState.transactionsUseCase.deleteTransactionRequestUseCase(requestId: requestId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      store.dispatch(RequestDeleted(requestId: requestId));
      snackBar(message: 'تمت العملية بنجاح', success: true, context: context);
    });
    store.dispatch(StopLoading());
  }
}

class RequestDeleted {
  final int requestId;

  RequestDeleted({this.requestId});
}

class GetTransactionRequestsAction implements TransactionsAction {
  GetTransactionRequestsAction();

  @override
  handle({Store<AppState> store}) async {
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
  }
}

class SetTransactionStatusId {
  final int transactionStatusId;

  SetTransactionStatusId({this.transactionStatusId});
}

class SetTransactionCategoryId {
  final int transactionCategoryId;

  SetTransactionCategoryId({this.transactionCategoryId});
}

class SetCreatedByMe {
  final int createdByMe;

  SetCreatedByMe({this.createdByMe});
}

class SetAssignedToMe {
  final int assignedToMe;

  SetAssignedToMe({this.assignedToMe});
}

class GetTransactionsAction implements TransactionsAction {
  final int adminId;

  GetTransactionsAction({this.adminId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionsUseCase(
      pageNumber: store.state.transactionsState.transactionsPage,
      adminId: store.state.adminsState.admin.permissions.contains(advancedTransactionPermission) ? adminId : null,
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
  }
}

class ParticularDayProfits implements TransactionsAction {
  final int adminId;
  final DateTime date;
  final BuildContext context;

  ParticularDayProfits({this.adminId, this.date, this.context});

  @override
  handle({Store<AppState> store}) async {
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
      adminId: adminId,
      groupingByParent: Services.hasPermission(context, advancedTransactionPermission)
          ? store.state.transactionsState.groupingTransactions
              ? 1
              : 0
          : 1,
      lastWeek: Services.hasPermission(context, advancedTransactionPermission) ? 0 : 1,
    );
    either.fold((failure) => error = true, (transactionsPage) {
      TransactionsPaginationEntity tempTransactions = transactionsPage;
      transactions.addAll(tempTransactions.transactions.where((transaction) => transaction.createdAt.day == date.day));
    });
    while (beforeNumber > 1) {
      length = transactions.length;
      either = await store.state.transactionsState.transactionsUseCase.getTransactionsUseCase(
          pageNumber: beforeNumber - 1,
          adminId: adminId,
          groupingByParent: Services.hasPermission(context, advancedTransactionPermission)
              ? store.state.transactionsState.groupingTransactions
                  ? 1
                  : 0
              : 1,
          lastWeek: Services.hasPermission(context, advancedTransactionPermission) ? 0 : 1);
      either.fold((failure) => error = true, (transactionsPage) {
        TransactionsPaginationEntity tempTransactions = transactionsPage;
        transactions
            .addAll(tempTransactions.transactions.where((transaction) => transaction.createdAt.day == date.day));

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
          adminId: adminId,
          groupingByParent: Services.hasPermission(context, advancedTransactionPermission)
              ? store.state.transactionsState.groupingTransactions
                  ? 1
                  : 0
              : 1,
          lastWeek: Services.hasPermission(context, advancedTransactionPermission) ? 0 : 1);
      either.fold((failure) => error = true, (transactionsPage) {
        TransactionsPaginationEntity tempTransactions = transactionsPage;
        transactions
            .addAll(tempTransactions.transactions.where((transaction) => transaction.createdAt.day == date.day));
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
      specificDayProfitWidget(context: context, date: date, transactions: transactions);
    }
  }
}

class GetAdminBalanceAction implements TransactionsAction {
  final int adminId;
  final BuildContext context;

  GetAdminBalanceAction({this.context, this.adminId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getAdminBalanceUseCase(adminId: adminId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (balance) {
      AdminBalanceEntity adminBalance = balance;
      adminBalanceWidget(context: context, balance: adminBalance);
    });
    store.dispatch(StopLoading());
  }
}

class GetShopperReportAction implements TransactionsAction {
  final int shopperId;

  GetShopperReportAction({this.shopperId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either =
        await store.state.transactionsState.transactionsUseCase.getShopperReportUseCase(shopperId: shopperId);
    either.fold((failure) {
      store.dispatch(SetShopperReport(
          shopperReport: ShopperReportEntity(
        deliveryDistance: 'error',
        avgDeliveryMinutes: 'error',
        avgOrderRating: 'error',
        countOrderThisMonth: 'error',
        dailyProfits: 'error',
        monthlyProfits: 'error',
        workingHour: 'error',
      )));
      store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً'));
    }, (shopperReport) => store.dispatch(SetShopperReport(shopperReport: shopperReport)));
    store.dispatch(StopLoading());
  }
}

class SetShopperReport {
  final ShopperReportEntity shopperReport;

  SetShopperReport({this.shopperReport});
}

class SetTransactionRequests {
  final List<TransactionRequestEntity> requests;

  SetTransactionRequests({this.requests});
}

class ClearTransactionRequests {
  ClearTransactionRequests();
}

class ClearTransactions {
  ClearTransactions();
}

class SetTransactions {
  final List<AdminTransactionEntity> transactions;

  SetTransactions({this.transactions});
}

class ChangeTransactionRequestStatusAction implements TransactionsAction {
  final int requestId;
  final int statusId;
  final String rejectReason;
  final BuildContext context;

  ChangeTransactionRequestStatusAction({this.requestId, this.statusId, this.rejectReason, this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase
        .changeTransactionRequestStatusUseCase(statusId: statusId, requestId: requestId, rejectReason: rejectReason);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (_) {
      store.dispatch(TransactionRequestChanged(rejectReason: rejectReason, requestId: requestId, statusId: statusId));
      snackBar(message: 'تمت العملية بنجاح', success: true, context: context);
    });
    store.dispatch(StopLoading());
  }
}

class TransactionRequestChanged {
  final int requestId;
  final int statusId;
  final String rejectReason;

  TransactionRequestChanged({this.requestId, this.statusId, this.rejectReason});
}

class SetGrouping {
  final bool grouping;

  SetGrouping({this.grouping});
}

class NextTransactionRequestsPage {}

class EndOfTransactionsRequests {}

class NextTransactionsPage {}

class PreviousTransactionsPage {}

class EndOfTransactions {}

class FirstRequestsPage {}

class FirstTransactionsPage {}

class RefreshRequests {}

class RefreshTransactions {}

class GetTransactionCategoriesAction implements TransactionsAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.transactionsState.transactionsUseCase.getTransactionCategoriesUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')),
        (categories) => store.dispatch(SetTransactionCategories(categories: categories)));
    store.dispatch(StopLoading());
  }

  GetTransactionCategoriesAction();
}

class SetTransactionCategories {
  final List<TransactionCategoryEntity> categories;

  SetTransactionCategories({this.categories});
}

class SetFilterCategories {
  final List<TransactionCategoryEntity> categories;

  SetFilterCategories({this.categories});
}

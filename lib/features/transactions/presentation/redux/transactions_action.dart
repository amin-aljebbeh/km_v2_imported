import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transaction_request_entity.dart';

class CreateTransactionAction {
  final bool pop;
  final BuildContext context;
  final AdminTransactionEntity transactionEntity;

  CreateTransactionAction({this.transactionEntity, this.context, this.pop = true});
}

class DeleteTransactionRequestAction {
  final int requestId;

  DeleteTransactionRequestAction({this.requestId});
}

class RequestDeleted {
  final int requestId;

  RequestDeleted({this.requestId});
}

class GetTransactionRequestsAction {
  GetTransactionRequestsAction();
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

class GetTransactionsAction {
  final int adminId;
  final int groupingByParent;

  GetTransactionsAction({this.adminId, this.groupingByParent});
}

class SetTransactionRequests {
  final List<TransactionRequestEntity> requests;

  SetTransactionRequests({this.requests});
}

class ClearTransactionRequests {
  final List<TransactionRequestEntity> requests;

  ClearTransactionRequests({this.requests});
}

class SetTransactions {
  final List<AdminTransactionEntity> transactions;

  SetTransactions({this.transactions});
}

class ChangeTransactionRequestStatusAction {
  final int requestId;
  final int statusId;
  final String rejectReason;

  ChangeTransactionRequestStatusAction({this.requestId, this.statusId, this.rejectReason});
}

class TransactionRequestChanged {
  final int requestId;
  final int statusId;
  final String rejectReason;

  TransactionRequestChanged({this.requestId, this.statusId, this.rejectReason});
}

class NextTransactionRequestsPage {}

class EndOfTransactionsRequests {}

class NextTransactionsPage {}

class EndOfTransactions {}

class FirstRequestsPage {}

class FirstTransactionsPage {}

class GetTransactionCategoriesAction {}

class SetTransactionCategories {
  final List<TransactionCategoryEntity> categories;

  SetTransactionCategories({this.categories});
}

class SetFilterCategories {
  final List<TransactionCategoryEntity> categories;

  SetFilterCategories({this.categories});
}

import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transaction_request_entity.dart';

class CreateTransactionRequestAction {
  final TransactionRequestEntity transactionRequestEntity;

  CreateTransactionRequestAction({this.transactionRequestEntity});
}

class CreateTransactionAction {
  final bool pop;
  final BuildContext context;
  final AdminTransactionEntity transactionEntity;

  CreateTransactionAction({this.transactionEntity, this.context, this.pop = true});
}

class DeleteTransactionRequestAction {
  final TransactionRequestEntity transactionRequestEntity;

  DeleteTransactionRequestAction({this.transactionRequestEntity});
}

class GetTransactionRequestsAction {
  final int assignedToMe;
  final int createdByMe;
  final int transactionStatusId;
  final int transactionCategoryId;

  GetTransactionRequestsAction(
      {this.assignedToMe, this.createdByMe, this.transactionStatusId, this.transactionCategoryId});
}

class GetTransactionsAction {}

class SetTransactionRequests {
  final List<TransactionRequestEntity> requests;

  SetTransactionRequests({this.requests});
}

class SetTransactions {
  final List<AdminTransactionEntity> transactions;

  SetTransactions({this.transactions});
}

class UpdateTransactionRequestAction {
  final TransactionRequestEntity transactionRequestEntity;

  UpdateTransactionRequestAction({this.transactionRequestEntity});
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

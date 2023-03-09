import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../domain/entities/admin_transaction_entity.dart';
import '../../domain/entities/transaction_request_entity.dart';

class CreateTransactionRequestAction {
  final TransactionRequestEntity transactionRequestEntity;

  CreateTransactionRequestAction({this.transactionRequestEntity});
}

class CreateTransactionAction {
  final AdminTransactionEntity transactionEntity;

  CreateTransactionAction({this.transactionEntity});
}

class DeleteTransactionRequestAction {
  final TransactionRequestEntity transactionRequestEntity;

  DeleteTransactionRequestAction({this.transactionRequestEntity});
}

class GetTransactionRequestsAction {}

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

class FirstPage {}

class GetTransactionCategoriesAction {}

class SetTransactionCategories {
  final List<TransactionCategoryEntity> categories;

  SetTransactionCategories({this.categories});
}

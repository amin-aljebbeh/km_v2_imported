import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/transactions/domain/use_cases/delete_transaction_request_use_case.dart';
import 'package:kammun_app/features/transactions/domain/use_cases/get_transaction_requests_use_case.dart';
import 'package:kammun_app/features/transactions/domain/use_cases/update_transaction_request_use_case.dart';

import 'create_transaction_request_use_case.dart';
import 'get_transaction_categories_use_case.dart';

class TransactionsUseCase {
  final CreateTransactionRequestUseCase createTransactionRequestUseCase;
  final DeleteTransactionRequestUseCase deleteTransactionRequestUseCase;
  final GetTransactionRequestsUseCase getTransactionRequestsUseCase;
  final UpdateTransactionRequestUseCase updateTransactionRequestUseCase;
  final GetTransactionCategoriesUseCase getTransactionCategoriesUseCase;

  TransactionsUseCase({
    @required this.createTransactionRequestUseCase,
    @required this.deleteTransactionRequestUseCase,
    @required this.getTransactionRequestsUseCase,
    @required this.updateTransactionRequestUseCase,
    @required this.getTransactionCategoriesUseCase,
  }) : assert(
          getTransactionCategoriesUseCase != null &&
              createTransactionRequestUseCase != null &&
              deleteTransactionRequestUseCase != null &&
              getTransactionRequestsUseCase != null &&
              updateTransactionRequestUseCase != null,
          'All use cases should be initialized.',
        );
}

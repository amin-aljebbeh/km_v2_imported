import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/transactions/domain/use_cases/delete_transaction_request_use_case.dart';
import 'package:kammun_app/features/transactions/domain/use_cases/get_transaction_requests_use_case.dart';
import 'package:kammun_app/features/transactions/domain/use_cases/update_transaction_request_use_case.dart';

import 'create_transaction_use_case.dart';
import 'get_admin_balance_use_case.dart';
import 'get_shopper_report_use_case.dart';
import 'get_transaction_categories_use_case.dart';
import 'get_transactions_use_case.dart';

class TransactionsUseCase {
  final CreateTransactionUseCase createTransactionUseCase;
  final DeleteTransactionRequestUseCase deleteTransactionRequestUseCase;
  final GetTransactionRequestsUseCase getTransactionRequestsUseCase;
  final ChangeTransactionRequestStatusUseCase changeTransactionRequestStatusUseCase;
  final GetTransactionCategoriesUseCase getTransactionCategoriesUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final GetShopperReportUseCase getShopperReportUseCase;
  final GetAdminBalanceUseCase getAdminBalanceUseCase;

  TransactionsUseCase({
    @required this.deleteTransactionRequestUseCase,
    @required this.getTransactionRequestsUseCase,
    @required this.changeTransactionRequestStatusUseCase,
    @required this.getTransactionCategoriesUseCase,
    @required this.createTransactionUseCase,
    @required this.getTransactionsUseCase,
    @required this.getShopperReportUseCase,
    @required this.getAdminBalanceUseCase,
  }) : assert(
          getTransactionCategoriesUseCase != null &&
              deleteTransactionRequestUseCase != null &&
              getTransactionRequestsUseCase != null &&
              getTransactionsUseCase != null &&
              createTransactionUseCase != null &&
              getShopperReportUseCase != null &&
              getAdminBalanceUseCase != null &&
              changeTransactionRequestStatusUseCase != null,
          'All use cases should be initialized.',
        );
}

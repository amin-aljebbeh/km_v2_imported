import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/supplier/domain/use_cases/account_statement_use_case.dart';

import 'remaining_statment_use_case.dart';

class SupplierUseCases {
  final AccountStatementUseCase getSupplierAccountStatementUseCase;
  final RemainingStatementUseCase remainingStatementUseCase;

  SupplierUseCases({@required this.getSupplierAccountStatementUseCase, @required this.remainingStatementUseCase})
      : assert(getSupplierAccountStatementUseCase != null && remainingStatementUseCase != null,
            'All use cases should ne initialized.');
}

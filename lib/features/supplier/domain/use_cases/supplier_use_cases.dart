import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/supplier/domain/use_cases/get_supplier_account_statement_use_case.dart';

class SupplierUseCases {
  final GetSupplierAccountStatementUseCase getSupplierAccountStatementUseCase;

  SupplierUseCases({@required this.getSupplierAccountStatementUseCase})
      : assert(getSupplierAccountStatementUseCase != null, 'All use cases should ne initialized.');
}

import '../../../../core/core_importer.dart';
import '../../domain/entities/supplier_account_statement_entity.dart';
import '../../domain/use_cases/supplier_use_cases.dart';

@immutable
class SupplierState extends Equatable {
  final SupplierUseCases supplierUseCases;
  final AccountStatementEntity accountStatement;

  const SupplierState({this.supplierUseCases, this.accountStatement});

  factory SupplierState.initial() {
    return SupplierState(
        supplierUseCases: sl<SupplierUseCases>(), accountStatement: const AccountStatementEntity(accountStatement: []));
  }

  SupplierState copyWith({AccountStatementEntity accountStatement}) {
    return SupplierState(
        accountStatement: accountStatement ?? this.accountStatement, supplierUseCases: supplierUseCases);
  }

  @override
  List<Object> get props => [supplierUseCases, accountStatement];
}

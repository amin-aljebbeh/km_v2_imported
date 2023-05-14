import '../../../../core/core_importer.dart';
import '../../domain/entities/account_statement_entity.dart';
import '../../domain/entities/remaining_statement_entity.dart';
import '../../domain/use_cases/supplier_use_cases.dart';

@immutable
class SupplierState extends Equatable {
  final SupplierUseCases supplierUseCases;
  final AccountStatementEntity accountStatement;
  final List<RemainingStatementEntity> remaining;

  const SupplierState({this.supplierUseCases, this.accountStatement, this.remaining});

  factory SupplierState.initial() {
    return SupplierState(
        supplierUseCases: sl<SupplierUseCases>(),
        remaining: const [],
        accountStatement: const AccountStatementEntity(accountStatement: []));
  }

  SupplierState copyWith({AccountStatementEntity accountStatement, List<RemainingStatementEntity> remaining}) {
    return SupplierState(
        accountStatement: accountStatement ?? this.accountStatement,
        remaining: remaining ?? this.remaining,
        supplierUseCases: supplierUseCases);
  }

  @override
  List<Object> get props => [supplierUseCases, accountStatement, remaining];
}

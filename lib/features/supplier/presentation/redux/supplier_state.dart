import 'package:kammun_app/features/supplier/domain/repositories/supplier_repository.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/supplier_account_statement_entity.dart';

@immutable
class SupplierState extends Equatable {
  final SupplierRepository supplierRepository;
  final AccountStatementEntity accountStatement;

  const SupplierState({this.supplierRepository, this.accountStatement});

  factory SupplierState.initial() {
    return SupplierState(
        supplierRepository: sl<SupplierRepository>(),
        accountStatement: const AccountStatementEntity(accountStatement: []));
  }

  SupplierState copyWith({AccountStatementEntity accountStatement}) {
    return SupplierState(
        accountStatement: accountStatement ?? this.accountStatement, supplierRepository: supplierRepository);
  }

  @override
  List<Object> get props => [supplierRepository, accountStatement];
}

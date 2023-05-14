import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/account_statement_entity.dart';
import '../repositories/supplier_repository.dart';

class AccountStatementUseCase {
  final SupplierRepository supplierRepository;

  AccountStatementUseCase({this.supplierRepository});

  Future<Either<Failure, AccountStatementEntity>> call({String from, String to}) async {
    return await supplierRepository.getSupplierAccountStatement(to: to, from: from);
  }
}

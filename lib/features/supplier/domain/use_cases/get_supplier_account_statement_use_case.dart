import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/supplier_account_statement_entity.dart';
import '../repositories/supplier_repository.dart';

class GetSupplierAccountStatementUseCase {
  final SupplierRepository supplierRepository;

  GetSupplierAccountStatementUseCase({this.supplierRepository});

  Future<Either<Failure, AccountStatementEntity>> call({String from, String to}) async {
    return await supplierRepository.getSupplierAccountStatement(to: to, from: from);
  }
}

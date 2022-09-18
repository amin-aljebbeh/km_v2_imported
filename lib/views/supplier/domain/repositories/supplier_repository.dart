import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/supplier_account_statement_entity.dart';

abstract class SupplierRepository {
  Future<Either<Failure, AccountStatementEntity>> getSupplierAccountStatement({String from, String to});
}

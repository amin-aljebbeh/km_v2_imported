import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/account_statement_entity.dart';
import '../entities/remaining_statement_entity.dart';

abstract class SupplierRepository {
  Future<Either<Failure, AccountStatementEntity>> getSupplierAccountStatement({String from, String to});
  Future<Either<Failure, List<RemainingStatementEntity>>> remainingMoneyForSupplier({String from, String to});
}

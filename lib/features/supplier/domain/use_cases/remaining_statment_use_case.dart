import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/remaining_statement_entity.dart';
import '../repositories/supplier_repository.dart';

class RemainingStatementUseCase {
  final SupplierRepository supplierRepository;

  RemainingStatementUseCase({this.supplierRepository});

  Future<Either<Failure, List<RemainingStatementEntity>>> call({String from, String to}) async {
    return await supplierRepository.remainingMoneyForSupplier(to: to, from: from);
  }
}

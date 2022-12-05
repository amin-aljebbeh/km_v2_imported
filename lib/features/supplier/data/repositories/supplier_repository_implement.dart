import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/supplier/data/data_sources/supplier_remote_data_source.dart';
import 'package:kammun_app/features/supplier/domain/entities/supplier_account_statement_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/supplier_repository.dart';

class SupplierRepositoryImplement implements SupplierRepository {
  final SupplierRemoteDataSource supplierRemoteDataSource;

  SupplierRepositoryImplement({this.supplierRemoteDataSource});
  @override
  Future<Either<Failure, AccountStatementEntity>> getSupplierAccountStatement({String from, String to}) async {
    try {
      AccountStatementEntity statment = await supplierRemoteDataSource.getSupplierAccountStatement(from: from, to: to);
      return Right(statment);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }
}

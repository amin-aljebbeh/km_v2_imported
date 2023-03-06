import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/data/models/transaction_model.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_request_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../data_sources/transactions_remote_data_source.dart';

class TransactionsRepositoryImplement extends TransactionsRepository {
  final TransactionRemoteDataSource transactionsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  TransactionsRepositoryImplement({this.transactionsRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> createTransactionRequest({TransactionRequestEntity transactionRequestEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            transactionsRemoteDataSource.createTransactionRequest(transactionRequestModel: transactionRequestEntity));
  }

  @override
  Future<Either<Failure, Unit>> deleteTransactionRequest({TransactionRequestEntity transactionRequestEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            transactionsRemoteDataSource.deleteTransactionRequest(transactionRequestModel: transactionRequestEntity));
  }

  @override
  Future<Either<Failure, List<TransactionRequestEntity>>> getTransactionRequests() async {
    try {
      List<TransactionRequestEntity> requests = await transactionsRemoteDataSource.getTransactionRequests();
      return Right(requests);
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

  @override
  Future<Either<Failure, Unit>> updateTransactionRequest({TransactionRequestEntity transactionRequestEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            transactionsRemoteDataSource.updateTransactionRequest(transactionRequestModel: transactionRequestEntity));
  }

  @override
  Future<Either<Failure, List<TransactionCategoryEntity>>> getTransactionCategories() async {
    try {
      List<TransactionCategoryEntity> categories = await transactionsRemoteDataSource.getTransactionCategories();
      return Right(categories);
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

  @override
  Future<Either<Failure, Unit>> createTransaction({TransactionEntity transactionEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => transactionsRemoteDataSource.createTransaction(
                transactionModel: TransactionModel(
              orderId: transactionEntity.orderId,
              userId: transactionEntity.userId,
              id: transactionEntity.id,
              description: transactionEntity.description,
              value: transactionEntity.value,
              adminId: transactionEntity.adminId,
              date: transactionEntity.date,
              actorId: transactionEntity.actorId,
              transactionCategoryId: transactionEntity.transactionCategoryId,
            )));
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions() async {
    try {
      List<TransactionEntity> transactions = await transactionsRemoteDataSource.getTransactions();
      return Right(transactions);
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

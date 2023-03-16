import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/data/models/admin_transaction_model.dart';
import 'package:kammun_app/features/transactions/domain/entities/admin_transaction_entity.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_request_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_requests_response_entity.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../data_sources/transactions_remote_data_source.dart';

class TransactionsRepositoryImplement extends TransactionsRepository {
  final TransactionRemoteDataSource transactionsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  TransactionsRepositoryImplement({this.transactionsRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> deleteTransactionRequest({TransactionRequestEntity transactionRequestEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            transactionsRemoteDataSource.deleteTransactionRequest(transactionRequestModel: transactionRequestEntity));
  }

  @override
  Future<Either<Failure, RequestsPaginationEntity>> getTransactionRequests(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber}) async {
    try {
      RequestsPaginationEntity requests = await transactionsRemoteDataSource.getTransactionRequests(
          transactionCategoryId: transactionCategoryId,
          assignedToMe: assignedToMe,
          createdByMe: createdByMe,
          pageNumber: pageNumber,
          transactionStatusId: transactionStatusId);
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
  Future<Either<Failure, Unit>> createTransaction({AdminTransactionEntity transactionEntity}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => transactionsRemoteDataSource.createTransaction(
                transactionModel: AdminTransactionModel(
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
  Future<Either<Failure, List<AdminTransactionEntity>>> getTransactions({int pageNumber}) async {
    try {
      List<AdminTransactionEntity> transactions =
          await transactionsRemoteDataSource.getTransactions(pageNumber: pageNumber);
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

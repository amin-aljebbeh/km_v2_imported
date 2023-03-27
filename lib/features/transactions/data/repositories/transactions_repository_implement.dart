import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/transactions/data/models/admin_transaction_model.dart';
import 'package:kammun_app/features/transactions/data/models/shopper_report_model.dart';
import 'package:kammun_app/features/transactions/domain/entities/admin_balance_entity.dart';
import 'package:kammun_app/features/transactions/domain/entities/admin_transaction_entity.dart';
import 'package:kammun_app/features/transactions/domain/entities/transaction_category_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/transaction_requests_response_entity.dart';
import '../../domain/entities/transactions_response_entity.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../data_sources/transactions_remote_data_source.dart';

class TransactionsRepositoryImplement extends TransactionsRepository {
  final TransactionRemoteDataSource transactionsRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  TransactionsRepositoryImplement({this.transactionsRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> deleteTransactionRequest({int requestId}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => transactionsRemoteDataSource.deleteTransactionRequest(requestId: requestId));
  }

  @override
  Future<Either<Failure, RequestsDataEntity>> getTransactionRequests(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber}) async {
    try {
      RequestsDataEntity requests = await transactionsRemoteDataSource.getTransactionRequests(
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
  Future<Either<Failure, Unit>> changeTransactionRequestStatus(
      {int requestId, int statusId, String rejectReason}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => transactionsRemoteDataSource.changeTransactionRequestStatus(
            statusId: statusId, requestId: requestId, rejectReason: rejectReason));
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
  Future<Either<Failure, TransactionsPaginationEntity>> getTransactions(
      {int pageNumber, int adminId, int lastWeek, int groupingByParent}) async {
    try {
      TransactionsPaginationEntity transactions = await transactionsRemoteDataSource.getTransactions(
          pageNumber: pageNumber, adminId: adminId, groupingByParent: groupingByParent, lastWeek: lastWeek);
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

  @override
  Future<Either<Failure, ShopperReportModel>> getShopperReport({int shopperId}) async {
    try {
      ShopperReportModel shopperReportModel = await transactionsRemoteDataSource.getShopperReport(shopperId: shopperId);
      return Right(shopperReportModel);
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
  Future<Either<Failure, AdminBalanceEntity>> getAdminBalance({int adminId}) async {
    try {
      AdminBalanceEntity adminBalance = await transactionsRemoteDataSource.getAdminBalance(adminId: adminId);
      return Right(adminBalance);
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

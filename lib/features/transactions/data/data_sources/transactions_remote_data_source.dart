import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/transaction_category_model.dart';
import '../models/transaction_model.dart';
import '../models/transaction_request_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionCategoryModel>> getTransactionCategories();
  Future<List<TransactionRequestModel>> getTransactionRequests();
  Future<List<TransactionModel>> getTransactions();
  Future<Unit> updateTransactionRequest({TransactionRequestModel transactionRequestModel});
  Future<Unit> deleteTransactionRequest({TransactionRequestModel transactionRequestModel});
  Future<Unit> createTransactionRequest({TransactionRequestModel transactionRequestModel});
  Future<Unit> createTransaction({TransactionModel transactionModel});
}

class TransactionsRemoteDataSourceImplement extends TransactionRemoteDataSource {
  @override
  Future<Unit> createTransactionRequest({TransactionRequestModel transactionRequestModel}) async {
    Response response = await ApiProvider.sendRequest(url: transactionRequestApi, method: HttpMethods.post);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> deleteTransactionRequest({TransactionRequestModel transactionRequestModel}) async {
    Response response = await ApiProvider.sendRequest(url: transactionRequestApi, method: HttpMethods.delete);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<TransactionRequestModel>> getTransactionRequests() async {
    Response response = await ApiProvider.sendRequest(url: transactionRequestApi, method: HttpMethods.get);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(null);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> updateTransactionRequest({TransactionRequestModel transactionRequestModel}) async {
    Response response = await ApiProvider.sendRequest(url: transactionRequestApi, method: HttpMethods.put);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<TransactionCategoryModel>> getTransactionCategories() async {
    Response response = await ApiProvider.sendRequest(url: transactionCategoryApi, method: HttpMethods.get);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(null);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> createTransaction({TransactionModel transactionModel}) async {
    Response response = await ApiProvider.sendRequest(
        url: transactionRequestApi, method: HttpMethods.post, queryParameters: transactionModel.toJson());
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    Response response = await ApiProvider.sendRequest(url: transactionCategoryApi, method: HttpMethods.get);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(null);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

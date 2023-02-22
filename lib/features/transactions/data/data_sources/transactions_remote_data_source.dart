import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/transaction_category_model.dart';
import '../models/transaction_request_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionCategoryModel>> getTransactionCategories();
  Future<List<TransactionRequestModel>> getTransactionRequests();
  Future<Unit> updateTransactionRequest({TransactionRequestModel transactionRequestModel});
  Future<Unit> deleteTransactionRequest({TransactionRequestModel transactionRequestModel});
  Future<Unit> createTransactionRequest({TransactionRequestModel transactionRequestModel});
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
}

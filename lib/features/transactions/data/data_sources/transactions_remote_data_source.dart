import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/admin_transaction_model.dart';
import '../models/categories_response_model.dart';
import '../models/transaction_category_model.dart';
import '../models/transaction_request_model.dart';
import '../models/transaction_requests_response_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionCategoryModel>> getTransactionCategories();

  Future<List<TransactionRequestModel>> getTransactionRequests(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber});

  Future<List<AdminTransactionModel>> getTransactions({int pageNumber});

  Future<Unit> updateTransactionRequest({TransactionRequestModel transactionRequestModel});

  Future<Unit> deleteTransactionRequest({TransactionRequestModel transactionRequestModel});

  Future<Unit> createTransactionRequest({TransactionRequestModel transactionRequestModel});

  Future<Unit> createTransaction({AdminTransactionModel transactionModel});
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
  Future<List<TransactionRequestModel>> getTransactionRequests(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(url: getMyRequestsApi, method: HttpMethods.get, queryParameters: {
      'page': pageNumber,
      'assigned_to_me': assignedToMe,
      'created_by_me': createdByMe,
      'transaction_status_id': transactionStatusId,
      'transaction_category_id': transactionCategoryId
    });
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return transactionRequestsResponseModelFromJson(jsonEncode(response.data)).requests;
        }
      }
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
      if (response != null) {
        if (response.statusCode == successCode) {
          return categoriesResponseModelFromJson(jsonEncode(response.data)).categories;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> createTransaction({AdminTransactionModel transactionModel}) async {
    Response response = await ApiProvider.sendRequest(
        url: addTransactionApiTemp, method: HttpMethods.post, queryParameters: transactionModel.toJson());
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<AdminTransactionModel>> getTransactions({int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: transactionApi, method: HttpMethods.get, queryParameters: {'page': pageNumber});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(null);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

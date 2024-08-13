import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/admin_balance_model.dart';
import '../models/admin_transaction_model.dart';
import '../models/categories_response_model.dart';
import '../models/shopper_report_model.dart';
import '../models/transaction_category_model.dart';
import '../models/transaction_requests_response_model.dart';
import '../models/transactions_response_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionCategoryModel>> getTransactionCategories();

  Future<RequestsDataModel> getTransactionRequests(
      {int assignedToMe, int createdByMe, int transactionStatusId, int transactionCategoryId, int pageNumber});

  Future<TransactionsPaginationModel> getTransactions(
      {int pageNumber, int adminId, int lastWeek, int groupingByParent});

  Future<Unit> changeTransactionRequestStatus({int requestId, int statusId, String rejectReason});

  Future<Unit> deleteTransactionRequest({int requestId});

  Future<Unit> createTransaction({AdminTransactionModel transactionModel});

  Future<ShopperReportModel> getShopperReport({int shopperId});

  Future<AdminBalanceModel> getAdminBalance({int adminId});
}

class TransactionsRemoteDataSourceImplement extends TransactionRemoteDataSource {
  @override
  Future<Unit> deleteTransactionRequest({int requestId}) async {
    Response response =
        await ApiProvider.sendRequest(url: transactionRequestApi + requestId.toString(), method: HttpMethods.delete);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<RequestsDataModel> getTransactionRequests(
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
          return transactionRequestsResponseModelFromJson(jsonEncode(response.data)).data;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> changeTransactionRequestStatus({int requestId, int statusId, String rejectReason}) async {
    Response response = await ApiProvider.sendRequest(
        url: changeTransactionRequestStatusApi,
        method: HttpMethods.put,
        body: {'transaction_request_id': requestId, 'transaction_status_id': statusId, 'reject_reasun': rejectReason});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<TransactionCategoryModel>> getTransactionCategories() async {
    Response response = await ApiProvider.sendRequest(url: categoriesTransactionsApi, method: HttpMethods.get);
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
  Future<TransactionsPaginationModel> getTransactions(
      {int pageNumber, int adminId, int lastWeek, int groupingByParent}) async {
    Map<String, dynamic> param = {
      'page': pageNumber,
      'admin_id': adminId,
      'lastWeek': lastWeek,
      'grouping_by_parent': groupingByParent
    };
    param.removeWhere((key, value) => value == null);
    Response response =
        await ApiProvider.sendRequest(url: getTransactionAdminApi, method: HttpMethods.get, queryParameters: param);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return transactionsResponseModelFromJson(jsonEncode(response.data)).transactionsPage;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<ShopperReportModel> getShopperReport({int shopperId}) async {
    Response response =
        await ApiProvider.sendRequest(url: shopperReportApi + shopperId.toString(), method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return shopperReportResponseModelFromJson(jsonEncode(response.data)).report;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<AdminBalanceModel> getAdminBalance({int adminId}) async {
    Response response = await ApiProvider.sendRequest(
        url: adminBalanceApi, method: HttpMethods.get, queryParameters: {'admin_id': adminId});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return adminBalanceResponseModelFromJson(jsonEncode(response.data)).adminBalance;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

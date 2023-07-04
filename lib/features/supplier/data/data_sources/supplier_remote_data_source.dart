import '../../../../core/core_importer.dart';
import '../models/account_statement_model.dart';
import '../models/remaining_statement_model.dart';

abstract class SupplierRemoteDataSource {
  Future<AccountStatementModel> getSupplierAccountStatement({String from, String to});
  Future<List<SupplierAccountModel>> remainingMoneyForSupplier({String from, String to});
}

class SupplierRemoteDataSourceImplement implements SupplierRemoteDataSource {
  @override
  Future<AccountStatementModel> getSupplierAccountStatement({String from, String to}) async {
    Response response = await ApiProvider.sendRequest(
        url: supplierAccountStatementApi, method: HttpMethods.get, queryParameters: {'from_date': from, 'to_date': to});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return supplierAccountStatementFromJson(jsonEncode(response.data)).data;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<SupplierAccountModel>> remainingMoneyForSupplier({String from, String to}) async {
    Response response = await ApiProvider.sendRequest(
        url: remainingMoneyForSupplierApi,
        method: HttpMethods.get,
        queryParameters: {'from_date': from, 'to_date': to});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return supplierRemainingModelResponseFromJson(jsonEncode(response.data)).data;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

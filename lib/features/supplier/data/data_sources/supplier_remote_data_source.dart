import '../../../../core/core_importer.dart';
import '../models/supplier_account_statement_model.dart';

abstract class SupplierRemoteDataSource {
  Future<AccountStatementModel> getSupplierAccountStatement({String from, String to});
}

class SupplierRemoteDataSourceImplement implements SupplierRemoteDataSource {
  @override
  Future<AccountStatementModel> getSupplierAccountStatement({String from, String to}) async {
    Response response = await ApiProvider.sendRequest(
        url: supplierAccountStatement, method: HttpMethods.get, queryParameters: {'from_date': from, 'to_date': to});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return supplierAccountStatementFromJson(jsonEncode(response.data)).data;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

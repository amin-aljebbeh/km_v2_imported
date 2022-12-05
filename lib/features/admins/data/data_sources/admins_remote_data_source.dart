import '../../../../core/core_importer.dart';
import '../models/admin_model.dart';
import '../models/get_admins_response_model.dart';

abstract class AdminsRemoteDataSource {
  Future<List<AdminModel>> getAdmins();
}

class AdminsRemoteDataSourceImplement extends AdminsRemoteDataSource {
  @override
  Future<List<AdminModel>> getAdmins() async {
    try {
      Response response = await ApiProvider.sendRequest(url: getProductsOfWaitingList, method: HttpMethods.get);
      if (response != null) {
        if (response.statusCode == successCode) return getAdminsResponseModelFromJson(jsonEncode(response.data)).admins;
      }
      throw (ServerException());
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
  }
}

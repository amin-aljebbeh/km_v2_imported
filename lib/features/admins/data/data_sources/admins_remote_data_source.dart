import '../../../../core/core_importer.dart';
import '../models/admin_model.dart';
import '../models/get_admins_response_model.dart';

abstract class AdminsRemoteDataSource {
  Future<List<AdminModel>> getAdmins();
}

class AdminsRemoteDataSourceImplement extends AdminsRemoteDataSource {
  @override
  Future<List<AdminModel>> getAdmins() async {
    Response response = await ApiProvider.sendRequest(url: admin, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getAdminsResponseModelFromJson(jsonEncode(response.data)).admins;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

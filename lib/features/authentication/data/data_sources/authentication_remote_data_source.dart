import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/login_admin_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Unit> login({String username, String password});
}

class AuthenticationRemoteDataSourceImplement implements AuthenticationRemoteDataSource {
  @override
  Future<Unit> login({String username, String password}) async {
    Map loginBody = {'username': username, 'password': password};
    Response response = await ApiProvider.sendRequest(
        url: loginApi, method: HttpMethods.post, body: jsonEncode(loginBody), responseType: ResponseType.json);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          final newResponse = adminLoginResponseFromJson(jsonEncode(response.data));
          SharedPreferences prefs = sl<SharedPreferences>();
          prefs.setString('userToken', newResponse.admin.apiToken);
          prefs.setString('adminId', newResponse.admin.id.toString());
          prefs.setBool('preferLeftSide', true);
          LoadingScreen.userToken = newResponse.admin.apiToken;
          return Future.value(unit);
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

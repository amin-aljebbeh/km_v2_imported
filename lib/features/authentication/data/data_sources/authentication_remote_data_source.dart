import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart' as package_info;

import '../../../../core/api/device_info_api.dart';
import '../../../../core/api/ip_info_api.dart';
import '../../../../core/api/package_info_api.dart';
import '../../../../core/core_importer.dart';
import '../models/login_admin_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Unit> login({String username, String password});
}

class AuthenticationRemoteDataSourceImplement
    implements AuthenticationRemoteDataSource {
  @override
  Future<Unit> login({String username, String password}) async {
    final packageName = await PackageInfoApi.getPackageName();
    final appVersion = await PackageInfoApi.getAppVersion();
    final ipAddress = await IpInfoApi.getIPAddress();
    final phone = await DeviceInfoApi.getPhoneInfo();
    final phoneVersion = await DeviceInfoApi.getPhoneVersion();
    final operatingSystem = await DeviceInfoApi.getOperatingSystem();
    final screenResolution = await DeviceInfoApi.getScreenResolution();

    Map loginBody = {
      'username': username,
      'password': password,
      'app_version': appVersion,
      'device_name': phone,
      'os_version': phoneVersion,
      'platform': operatingSystem
    };
    Response response = await ApiProvider.sendRequest(
        url: loginApi,
        method: HttpMethods.post,
        body: jsonEncode(loginBody),
        responseType: ResponseType.json);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          final newResponse =
              adminLoginResponseFromJson(jsonEncode(response.data));
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

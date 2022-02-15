import 'dart:convert';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportedCityServices {
  static Future<bool> updateUserSupportedCity({String supportedCityId}) async {
    try {
      Map body = {"supported_city_id": int.parse(supportedCityId)};
      var response = await ApiProvider.sendRequest(
          url: UPDATE_USER_SUPPORTED_CITY, method: httpMethods.post, body: jsonEncode(body));

      if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("supportedCitySelected", "true");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

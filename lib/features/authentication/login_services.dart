import 'package:kammun_app/core/core_importer.dart';

class LoginServices {
  static Future<bool> checkIfUserLoggedIn() async {
    try {
      SharedPreferences prefs = sl<SharedPreferences>();
      // prefs.clear();
      StaticVariables.preferLeftSide = prefs.getBool('preferLeftSide');
      String userToken = prefs.getString('userToken');
      if (userToken != null) {
        LoadingScreen.userToken = 'Bearer ' + userToken;
        if (userToken == 'APPLE_VERIFICATION') {
          baseUrl = appleBaseUrl;
        } else {
          baseUrl = productionBaseUrl;
        }
        if (['shopper', 'supplier', 'rabia', 'agent', 'collector'].contains(userToken)) baseUrl = testUrl;
        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }
}

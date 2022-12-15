import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/login/models/login_admin_model.dart';

class LoginServices {
  static String replaceFarsiNumber(String s) {
    var sb = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      switch (s[i]) {
        case '\u06f0':
        case '\u0660':
          sb.write('0');
          break;
        case '\u06f1':
        case '\u0661':
          sb.write('1');
          break;
        case '\u06f2':
        case '\u0662':
          sb.write('2');
          break;
        case '\u06f3':
        case '\u0663':
          sb.write('3');
          break;
        case '\u06f4':
        case '\u0664':
          sb.write('4');
          break;
        case '\u06f5':
        case '\u0665':
          sb.write('5');
          break;
        case '\u06f6':
        case '\u0666':
          sb.write('6');
          break;
        case '\u06f7':
        case '\u0667':
          sb.write('7');
          break;
        case '\u06f8':
        case '\u0668':
          sb.write('8');
          break;
        case '\u06f9':
        case '\u0669':
          sb.write('9');
          break;
        default:
          sb.write(s[i]);
          break;
      }
    }
    return sb.toString();
  }

  static Future<bool> loginAdmin({String username, String password}) async {
    Map loginBody = {'username': username, 'password': password};
    try {
      var response = await ApiProvider.sendRequest(
          url: login, method: HttpMethods.post, body: jsonEncode(loginBody), responseType: ResponseType.json);
      var theResponse = response.data;
      if (response.statusCode == successCode && (theResponse['success'].toString() == 'true')) {
        final newResponse = adminLoginResponseFromJson(jsonEncode(response.data));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userToken', newResponse.data.apiToken);
        prefs.setString('adminRoll', username);
        prefs.setString('adminId', newResponse.data.id.toString());
        prefs.setBool('preferLeftSide', true);
        LoadingScreen.userToken = newResponse.data.apiToken;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logOutAdmin(BuildContext context) async {
    LoadingScreenServices.allOrdersList = [];
    LoadingScreenServices.myOrdersList = [];
    LoadingScreenServices.phoneOrderList = [];
    LoadingScreenServices.ordersViewFilter = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = appUrl;
    await preferences.clear();
    KammunRestart.restartApp(context);
  }
}

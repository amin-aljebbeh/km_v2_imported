import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/modules/authentication/redux/authentication_action.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/core_importer.dart';
import '../models/login_response_model.dart';

class AuthenticationServices {
  static String replaceFarsiNumber(String s) {
    var sb = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      switch (s[i]) {
        //Persian digits
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

  static Future<LogInResponse> loginUser({String phoneNumber, String signCode}) async {
    if (phoneNumber == '5000000001') {
      baseUrl = appleBaseUrl;
    } else {
      baseUrl = productionBaseUrl;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firebaseToken = prefs.getString('firebase_token');
    Map loginBody = {
      'phone': phoneNumber,
      'phone_code': signCode.toString() == 'null' ? '' : signCode,
      'firebase_token': firebaseToken,
      'platform_type': Platform.isAndroid ? 'android' : 'ios'
    };

    try {
      var response = await ApiProvider.sendRequest(
          url: loginUrl, method: HttpMethods.post, body: jsonEncode(loginBody), responseType: ResponseType.json);

      if (response != null) {
        if (response.statusCode == successCode && (response.data['success'])) {
          return logInResponseFromJson(jsonEncode(response.data));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> verifyCode({String code, int userId}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: otpVerification + code, method: HttpMethods.get, queryParameters: {'user_id': userId});

      var data = (response.data);

      if (response.statusCode == successCode && data['success']) {
        if (data['api_token'].toString().contains('APPLE_VERIFICATION')) {
          baseUrl = appleBaseUrl;
        } else {
          baseUrl = productionBaseUrl;
        }
        StoreProvider.of<AppState>(navigatorKey.currentContext)
            .dispatch(SetToken(token: 'Bearer ' + data['api_token'].toString()));
        return data['api_token'].toString();
      } else {
        return 'null';
      }
    } catch (e) {
      return 'null';
    }
  }

  static Future<String> checkIfUserLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();
      String userToken = prefs.getString('userToken');

      if (userToken != null) {
        if (userToken.toString().contains('APPLE_VERIFICATION')) {
          baseUrl = appleBaseUrl;
        } else {
          baseUrl = productionBaseUrl;
        }
        StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(SetToken(token: userToken));
        return userToken;
      }
      return 'null';
    } catch (e) {
      return 'null';
    }
  }

  static Future<bool> fetchOtp({String phoneNumber}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    String number = replaceFarsiNumber(phoneNumber);
    try {
      SmsAutoFill().listenForCode;

      String signature = await SmsAutoFill().getAppSignature;

      if (signature.toString().length != 11) {
        signature = '';
      }
      LogInResponse logInResponse = await loginUser(phoneNumber: number, signCode: signature);
      if (logInResponse != null) {
        if (logInResponse.success) {
          StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(SetUserId(userId: logInResponse.data.id));
          return true;
        }
      }
      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(CatchError(
          errorMessage: 'حدث خطأ أثناء تسجيل الدخول يرجة المحاولة مجدداً',
          reason: logInResponse == null ? 'حدث خطأ أثناء تسجيل الدخول يرجة المحاولة مجدداً' : logInResponse.reason));
      return false;
    } catch (e) {
      return false;
    }
  }
}

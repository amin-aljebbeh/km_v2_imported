import '../../../core/core_importer.dart';

class ErrorServices {
  static Future logUserError({String url, String reason, int statusCode, int userId}) async {
    try {
      Map errorBody = {'action': url ?? ' ', 'reason': reason, 'status': statusCode, 'user_id': userId};
      await ApiProvider.sendRequest(url: storeUserError, method: HttpMethods.post, body: jsonEncode(errorBody));
    } catch (e) {
      /**/
    }
  }
}

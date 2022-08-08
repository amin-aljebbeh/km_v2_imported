import 'package:dio/dio.dart';
import '../core_importer.dart';

class ApiProvider {
  static Future<Response> sendRequest({
    @required String url,
    dynamic body,
    Map<String, dynamic> queryParameters,
    @required HttpMethods method,
    ResponseType responseType,
  }) async {
    var options = BaseOptions(
        baseUrl: baseUrl + '/api/', connectTimeout: 30000, receiveTimeout: 30000, contentType: Headers.jsonContentType);

    var dio = Dio(options);
    String token;
    try {
      token = StoreProvider.of<AppState>(navigatorKey.currentContext).state.authenticationState.token;
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('userToken');
    }
    Tools.logToConsole(token);
    Tools.logToConsole(body);
    Tools.logToConsole(queryParameters);
    Tools.logToConsole(method.toString());
    Tools.logToConsole(baseUrl + '/api/' + url);
    if (url != storeUserError) {
      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(SetUrl(url: url));
    }
    Map<String, String> header = {'Authorization': 'Bearer ' + token ?? ''};

    Response response;

    try {
      switch (method) {
        case HttpMethods.get:
          {
            response = await dio.get(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
            );
            break;
          }
        case HttpMethods.delete:
          {
            response = await dio.delete(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
            );
            break;
          }
        case HttpMethods.put:
          {
            response = await dio.put(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
              data: body,
            );
            break;
          }

        case HttpMethods.post:
          {
            response = await dio.post(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, validateStatus: (status) => status < 500),
              data: body,
            );
            break;
          }
      }
    } on DioError catch (e) {
      Tools.logToConsole(e.message);
    }
    if (response != null) {
      Tools.logToConsole(response.statusCode);
      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(SetStatusCode(statusCode: response.statusCode));
    }
    Tools.logToConsole('response is :');
    Tools.logToConsole(response);
    return response;
  }
}

enum HttpMethods { get, post, put, delete }

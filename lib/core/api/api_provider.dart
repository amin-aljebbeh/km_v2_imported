import 'package:dio/dio.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import '../../core/errors/error_handler.dart';
import 'api_URLs.dart';

class ApiProvider {
  static Future<Response> sendRequest(
      {String url,
      dynamic body,
      Map<String, dynamic> queryParameters,
      httpMethods method,
      ResponseType reponseType,
      bool mapService,
      bool isUrlEncodedFormat}) async {
    Tools.logToConsole("---------------------service url : ");
    Tools.logToConsole(BaseUrl + url);
    Tools.logToConsole(body);
    Tools.logToConsole(method);
    Tools.logToConsole("-----------------------------------");

    if (mapService == null) mapService = false;
    if (isUrlEncodedFormat == null) isUrlEncodedFormat = false;

    var options = BaseOptions(
        baseUrl: mapService ? "" : BaseUrl,
        connectTimeout: 40000,
        receiveTimeout: 40000,
        contentType: isUrlEncodedFormat
            ? Headers.formUrlEncodedContentType
            : Headers.jsonContentType);

    var dio = new Dio(options);

    // Master Version //
    // --------------------------------------- //
    // Map<String, String> header = {
    //   'Authorization':
    //       LoadingScreen.user_token.length > 5 ? LoadingScreen.user_token : "",
    // };
    // --------------------------------------- //

    Tools.logToConsole("------- THE USER TOKEN IS ----------");
    Tools.logToConsole(LoadingScreen.user_token);
    Map<String, String> header = {
      // 'Authorization': "Bearer user",

      'Authorization':
          LoadingScreen.user_token.length > 10 ? LoadingScreen.user_token : "",
    };

    Response response;

    try {
      switch (method) {
        case httpMethods.get:
          {
            response = await dio.get(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: reponseType),
            );
            break;
          }
        case httpMethods.delete:
          {
            response = await dio.delete(
              url,
              data: body,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: reponseType),
            );
            break;
          }
        case httpMethods.put:
          {
            response = await dio.put(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: reponseType),
              data: body,
            );
            break;
          }

        case httpMethods.post:
          {
            response = await dio.post(url,
                queryParameters: queryParameters,
                options: Options(headers: header),
                data: body);
            break;
          }
      }
    } on DioError catch (e) {
      Tools.logToConsole(
          "------------------------ API Exception --------------------------------------");

      return ErrorHandler.handleDioError(e);
    }

    return response;
  }
}

enum httpMethods { get, post, put, delete }

import 'package:dio/dio.dart';
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
    print("---------------------service url : ");
    print(BaseUrl + url);
    print(body);
    print(method);
    print("-----------------------------------");

    if (mapService == null) mapService = false;
    if (isUrlEncodedFormat == null) isUrlEncodedFormat = false;

    var options = BaseOptions(
        baseUrl: mapService ? "" : BaseUrl,
        connectTimeout: 20000,
        receiveTimeout: 20000,
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

    //print("------- THE USER TOKEN IS ----------");
    //print(LoadingScreen.user_token);
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
      print(
          "------------------------ API Exception --------------------------------------");

      return ErrorHandler.handleDioError(e);
    }

    return response;
  }
}

enum httpMethods { get, post, put, delete }

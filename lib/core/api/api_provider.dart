import 'package:dio/dio.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import '../../core/errors/error_handler.dart';
import 'api_URLs.dart';

class ApiProvider {
  static Future<Response> sendRequest(
      {String url,
      dynamic body,
      Map<String, dynamic> queryParameters,
      httpMethods method,
      ResponseType responseType,
      bool mapService,
      bool isUrlEncodedFormat}) async {
    if (mapService == null) mapService = false;
    if (isUrlEncodedFormat == null) isUrlEncodedFormat = false;

    var options = BaseOptions(
        baseUrl: mapService ? "" : BASE_URL,
        connectTimeout: 40000,
        receiveTimeout: 40000,
        contentType: isUrlEncodedFormat
            ? Headers.formUrlEncodedContentType
            : Headers.jsonContentType);

    var dio = new Dio(options);

    Map<String, String> header = {
      'Authorization':
          LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : "",
    };

    Response response;

    try {
      switch (method) {
        case httpMethods.get:
          {
            response = await dio.get(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
            );
            break;
          }
        case httpMethods.delete:
          {
            response = await dio.delete(
              url,
              data: body,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
            );
            break;
          }
        case httpMethods.put:
          {
            response = await dio.put(
              url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
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
    } on NoSuchMethodError catch (e) {
      Tools.logToConsole('message from selected error');
      Tools.logToConsole(e.toString());
    }

    return response;
  }
}

enum httpMethods { get, post, put, delete }

import 'package:dio/dio.dart';
import 'package:kammun_app/views/loading/Loading.dart';

import '../../core/core_importer.dart';

class ApiProvider {
  static Future<Response> sendRequest(
      {String url,
      dynamic body,
      Map<String, dynamic> queryParameters,
      HttpMethods method,
      ResponseType responseType,
      bool mapService,
      bool isUrlEncodedFormat}) async {
    mapService ??= false;
    isUrlEncodedFormat ??= false;

    var options = BaseOptions(
        baseUrl: mapService ? "" : baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        contentType: isUrlEncodedFormat ? Headers.formUrlEncodedContentType : Headers.jsonContentType);

    var dio = Dio(options);

    Map<String, String> header = {
      'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : "",
    };

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
            response = await dio.post(url,
                queryParameters: queryParameters, options: Options(headers: header), data: body);
            break;
          }
      }
    } on DioError catch (e) {
      RequestOptions requestOptions = RequestOptions(
        path: url,
      );
      return ErrorHandler.handleDioError(e, requestOptions);
    }

    return response;
  }
}

enum HttpMethods { get, post, put, delete }

import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../features/orders/orders_services.dart';
import '../core_importer.dart';

class ApiProvider {
  static Future<Response> sendRequest({
    @required String url,
    dynamic body,
    Map<String, dynamic> queryParameters,
    @required HttpMethods method,
    ResponseType responseType,
    CancelToken cancelToken,
  }) async {
    //
    var options = BaseOptions(
        baseUrl: baseUrl + '/api/',
        /*connectTimeout: 30000, receiveTimeout: 30000, */ contentType: Headers.jsonContentType);

    var dio = Dio(options);
    String token = LoadingScreen.userToken;
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: true,
          responseHeader: false,
          request: true,
          error: true,
          compact: false,
          maxWidth: 90));
    }
    Map<String, String> header = {'Authorization': token ?? ''};

    Response response;

    try {
      switch (method) {
        case HttpMethods.get:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: Options(headers: header, responseType: responseType),
          );
          break;
        case HttpMethods.delete:
          response = await dio.delete(url,
              queryParameters: queryParameters, options: Options(headers: header, responseType: responseType));
          break;
        case HttpMethods.put:
          response = await dio.put(url,
              queryParameters: queryParameters,
              options: Options(headers: header, responseType: responseType),
              data: body);
          break;

        case HttpMethods.post:
          response = await dio.post(url,
              queryParameters: queryParameters,
              options: Options(headers: header, validateStatus: (status) => status < 500),
              data: body);
          break;
      }
      if (response.statusCode == updateRequiredCode) {
        throw (UpdateRequiredException());
      }
    } on DioError catch (e) {
      return ErrorHandler.handleDioError(e, RequestOptions(path: url));
    } on UpdateRequiredException {
      throw (UpdateRequiredException());
    } catch (e) {
      Tools.logToConsole(e.message);
    }
    return response;
  }

  static void cancelOrdersRequests() {
    OrdersServices.cancelRequest.cancel('Cancelled');
    OrdersServices.cancelRequest = CancelToken();
  }
}

enum HttpMethods { get, post, put, delete }

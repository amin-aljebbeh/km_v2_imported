import '../../features/orders_feature/orders_services.dart';
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
    var options = BaseOptions(
        baseUrl: baseUrl + '/api/', connectTimeout: 30000, receiveTimeout: 30000, contentType: Headers.jsonContentType);

    var dio = Dio(options);
    String token = LoadingScreen.userToken;
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
    } on DioError catch (e) {
      Tools.logToConsole(token);
      Tools.logToConsole(body);
      Tools.logToConsole(queryParameters);
      Tools.logToConsole(method.toString());
      Tools.logToConsole(baseUrl + '/api/' + url);
      Tools.logToConsole(e.message);
      Tools.logToConsole(ErrorHandler.handleDioError(e, RequestOptions(path: url)).data);
      return ErrorHandler.handleDioError(e, RequestOptions(path: url));
    } catch (e) {
      Tools.logToConsole(e.message);
    }
    Tools.logToConsole(token);
    Tools.logToConsole(body);
    Tools.logToConsole(queryParameters);
    Tools.logToConsole(method.toString());
    Tools.logToConsole(baseUrl + '/api/' + url);
    if (response != null) Tools.logToConsole(response.statusCode);
    Tools.logToConsole('response is :');
    Tools.logToConsole(response);
    return response;
  }

  static void cancelOrdersRequests() {
    OrdersServices.cancelRequest.cancel('Cancelled');
    OrdersServices.cancelRequest = CancelToken();
  }
}

enum HttpMethods { get, post, put, delete }

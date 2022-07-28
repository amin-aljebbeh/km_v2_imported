import '../core_importer.dart';

class ErrorHandler {
  static Response handleDioError(DioError error, RequestOptions options) {
    if (error.response == null) {
      return Response(statusCode: serviceUnavailableError, requestOptions: options);
    } else {
      if (error.type == DioErrorType.other || error.type == DioErrorType.response) {
        if (error is SocketException) return error.response;
        if (error.type == DioErrorType.response) {
          switch (error.response.statusCode) {
            case badRequestError:
              {
                return error.response;
              }
            case unauthorizedError:
              return error.response;

            case forbiddenError:
              return error.response;

            case notFoundError:
              return error.response;

            case conflictError:
              return error.response;

            case internalServerError:
              return error.response;

            default:
              return error.response;
          }
        } else if (error.type == DioErrorType.connectTimeout ||
            error.type == DioErrorType.sendTimeout ||
            error.type == DioErrorType.receiveTimeout) {
          return error.response;
        } else if (error.type == DioErrorType.cancel) {
          return error.response;
        } else {
          return error.response;
        }
      }
      return error.response;
    }
  }
}

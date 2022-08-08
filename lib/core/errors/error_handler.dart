import 'dart:io';
import 'package:dio/dio.dart';
import 'error_types.dart';

class ErrorHandler {
  static Response handleDioError(DioError error, RequestOptions options) {
    if (error.response == null) {
      return Response(statusCode: serviceUnavailableError);
    } else {
      if (error.type == DioErrorType.DEFAULT || error.type == DioErrorType.RESPONSE) {
        if (error is SocketException) return error.response;
        if (error.type == DioErrorType.RESPONSE) {
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
        } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
            error.type == DioErrorType.SEND_TIMEOUT ||
            error.type == DioErrorType.RECEIVE_TIMEOUT) {
          return error.response;
        } else if (error.type == DioErrorType.CANCEL) {
          return error.response;
        } else {
          return error.response;
        }
      }
      return error.response;
    }
  }
}

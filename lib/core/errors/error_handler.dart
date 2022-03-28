import 'dart:io';

import 'package:dio/dio.dart';

import '../core_importer.dart';

class ErrorHandler {
  static Response handleDioError(DioError error, RequestOptions options) {
    if (error.response == null) {
      return Response(statusCode: SERVICE_UNAVAILABLE_ERROR, requestOptions: options);
    } else {
      if (error.type == DioErrorType.other || error.type == DioErrorType.response) {
        if (error is SocketException) return error.response;
        if (error.type == DioErrorType.response) {
          switch (error.response.statusCode) {
            case BAD_REQUEST_ERROR:
              {
                return error.response;
              }
            case UNAUTHORIZED_ERROR:
              return error.response;

            case FORBIDDEN_ERROR:
              return error.response;

            case NOT_FOUND_ERROR:
              return error.response;

            case CONFLICT_ERROR:
              return error.response;

            case INTERNAL_SERVER_ERROR:
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
        } else
          return error.response;
      }
      return error.response;
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kammun_app/utils/tools.dart';
import '../core_importer.dart';

class ErrorHandler {
  static Response handleDioError(DioError error) {
    Tools.logToConsole("Dio error : " + error.message);

    if (error.response == null) {
      Tools.logToConsole("-------Service Unavailable--------");

      return Response(statusCode: SERVICE_UNAVAILABLE_ERROR);
    } else {
      if (error.type == DioErrorType.DEFAULT || error.type == DioErrorType.RESPONSE) {
        if (error is SocketException) return error.response;
        if (error.type == DioErrorType.RESPONSE) {
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
        } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
            error.type == DioErrorType.SEND_TIMEOUT ||
            error.type == DioErrorType.RECEIVE_TIMEOUT) {
          return error.response;
        } else if (error.type == DioErrorType.CANCEL) {
          return error.response;
        } else
          return error.response;
      }
      return error.response;
    }
  }
}

import 'package:flutter/cupertino.dart';

class OfflineException implements Exception {}

class ServerException implements Exception {}

class CacheException implements Exception {}

class InternalException implements Exception {
  final String message;

  InternalException({@required this.message});
}

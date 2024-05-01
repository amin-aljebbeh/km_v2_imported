import 'package:flutter/cupertino.dart';

class OfflineException implements Exception {}

class ServerException implements Exception {}

class UpdateRequiredException implements Exception {
  final String message;

  UpdateRequiredException(
      {this.message = ' لديك نسخة قديمة من التطبيق يرجى التحديث حتى تتمكن من الإستفادة من خدمات كمّون'});
}

class OfflineRegionException implements Exception {
  final String message;

  OfflineRegionException(
      {this.message = 'نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل'});
}

class CacheException implements Exception {}

class LocalException implements Exception {
  final String message;

  LocalException({@required this.message});
}

class InternalException implements Exception {
  final String message;

  InternalException({@required this.message});
}

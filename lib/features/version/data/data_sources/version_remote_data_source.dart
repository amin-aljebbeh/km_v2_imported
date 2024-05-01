import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class VersionRemoteDataSource {
  Future<Unit> checkVersion({String appVersion, String platform});
}

class VersionRemoteDataSourceImplement implements VersionRemoteDataSource {
  @override
  Future<Unit> checkVersion({String appVersion, String platform}) async {
    Response response = await ApiProvider.sendRequest(
        url: checkVersionApi,
        method: HttpMethods.get,
        queryParameters: {'app_version': appVersion, 'platform': platform});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return Future.value(unit);
        if (response.statusCode == 426) throw (UpdateRequiredException());
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

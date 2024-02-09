import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class AuthenticationLocalDataSource {
  Future<Unit> logout();
}

class AuthenticationLocalDataSourceImplement implements AuthenticationLocalDataSource {
  @override
  Future<Unit> logout() async {
    SharedPreferences preferences = sl<SharedPreferences>();
    baseUrl = baseUrl;
    await preferences.clear();
    return Future.value(unit);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class UsersRemoteDataSource {
  Future<Unit> attachUserToCoupon({int couponId, int userId, int availability});
  Future<Unit> depositUserWalletToCoupon({int userId, int value, String description});
}

class UsersRemoteDataSourceImplement implements UsersRemoteDataSource {
  @override
  Future<Unit> attachUserToCoupon({int couponId, int userId, int availability}) async {
    Response response = await ApiProvider.sendRequest(
        url: attachUserToCouponApi + couponId.toString(),
        method: HttpMethods.post,
        body: {'user_id': userId, 'availability': availability});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> depositUserWalletToCoupon({int userId, int value, String description}) async {
    Response response = await ApiProvider.sendRequest(
        url: depositApi, method: HttpMethods.post, body: {'user_id': userId, 'value': value});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

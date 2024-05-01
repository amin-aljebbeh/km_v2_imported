import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class UsersRemoteDataSource {
  Future<Unit> attachUserToCoupon({int couponId, int userId, int availability});
  Future<Unit> changeNumberPhoneUser({int userId, String phoneNumber});
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
  Future<Unit> changeNumberPhoneUser({int userId, String phoneNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: userChangePhoneApi + userId.toString(), method: HttpMethods.put, body: {'phone': phoneNumber});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

import '../../../../core/core_importer.dart';
import '../models/coupon_model.dart';
import '../models/get_coupons_model.dart';
import '../models/user_coupons_response_model.dart';

abstract class CouponRemoteDataSource {
  Future<GetCouponsResponseModel> getCoupons({int isGeneral, int isForDelivery, String code, int page});
  Future<List<CouponModel>> getUserCoupons({int userId});
}

class CouponRemoteDataSourceImplement implements CouponRemoteDataSource {
  @override
  Future<GetCouponsResponseModel> getCoupons({int isGeneral, int isForDelivery, String code, int page}) async {
    Map<String, dynamic> params = {
      'is_general': isGeneral,
      'is_for_delivery': isForDelivery,
      'code': code,
      'page': page
    };
    params.removeWhere((key, value) => value == null);
    Response response = await ApiProvider.sendRequest(url: couponApi, method: HttpMethods.get, queryParameters: params);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return couponsModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<CouponModel>> getUserCoupons({int userId}) async {
    Response response = await ApiProvider.sendRequest(url: userCouponsApi + userId.toString(), method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return userCouponsResponseModelFromJson(jsonEncode(response.data)).data.coupons;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

import '../../../../core/core_importer.dart';
import '../models/coupon_model.dart';
import '../models/get_coupons_model.dart';

abstract class CouponRemoteDataSource {
  Future<List<CouponModel>> getCoupons({int isGeneral, int isForDelivery, String code});
}

class CouponRemoteDataSourceImplement implements CouponRemoteDataSource {
  @override
  Future<List<CouponModel>> getCoupons({int isGeneral, int isForDelivery, String code}) async {
    Map<String, dynamic> params = {'is_general': isGeneral, 'is_for_delivery': isForDelivery, 'code': code};
    params.removeWhere((key, value) => value == null);
    Response response = await ApiProvider.sendRequest(url: couponApi, method: HttpMethods.get, queryParameters: params);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return couponsModelFromJson(jsonEncode(response.data)).data.coupons;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

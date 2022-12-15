import '../../../../core/core_importer.dart';
import '../models/get_coupons_model.dart';

abstract class CouponRemoteDataSource {
  Future<GetCouponsResponseModel> getCoupons({int isGeneral, int isForDelivery, String code, int page});
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
}

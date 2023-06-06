import '../../../../core/core_importer.dart';
import '../../../products/data/models/product_model.dart';
import '../models/get_cart_model.dart';
import '../models/submit_order_model.dart';
import '../models/update_order_response_model.dart';

abstract class CartRemoteDataSource {
  Future<UpdateOrderResponseModel> updateOrder({int orderId, SubmitOrderModel submitOrderModel});

  Future<List<ProductModel>> getCart({String cart});
}

class CartRemoteDataSourceImplement implements CartRemoteDataSource {
  @override
  Future<UpdateOrderResponseModel> updateOrder({int orderId, SubmitOrderModel submitOrderModel}) async {
    Response response = await ApiProvider.sendRequest(
        url: orderApi + orderId.toString(), method: HttpMethods.put, body: jsonEncode(submitOrderModel.toJson()));
    try {
      if (response != null) {
        if (response.statusCode == successCode || response.statusCode == badRequestError) {
          return updateOrderModelFromJson(jsonEncode(response.data));
        }
        if (response.data['reason'].toString().contains('discontinued')) throw (OfflineRegionException());
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ProductModel>> getCart({String cart}) async {
    Response response = await ApiProvider.sendRequest(
        url: syncCartApi,
        method: HttpMethods.post,
        body: jsonEncode({
          'product_ids': cart.split('@')[0].replaceRange(cart.split('@')[0].length - 1, cart.split('@')[0].length, "")
        }));
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getCartFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

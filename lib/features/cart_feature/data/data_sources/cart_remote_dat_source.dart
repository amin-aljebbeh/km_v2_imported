import '../../../../core/core_importer.dart';
import '../models/submit_order_model.dart';
import '../models/update_order_response_model.dart';

abstract class CartRemoteDataSource {
  Future<UpdateOrderResponseModel> updateOrder({int orderId, SubmitOrderModel submitOrderModel});
}

class CartRemoteDataSourceImplement implements CartRemoteDataSource {
  @override
  Future<UpdateOrderResponseModel> updateOrder({int orderId, SubmitOrderModel submitOrderModel}) async {
    Response response = await ApiProvider.sendRequest(
        url: lockOrderApi + orderId.toString(), method: HttpMethods.put, body: jsonEncode(submitOrderModel.toJson()));
    try {
      if (response != null) {
        if (response.statusCode == successCode) return updateOrderModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

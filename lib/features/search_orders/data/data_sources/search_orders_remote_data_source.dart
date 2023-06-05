import '../../../../core/core_importer.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/data/models/orders_model.dart';
import '../models/get_order_response_model.dart';

abstract class SearchOrdersRemoteDataSource {
  Future<List<OrderModel>> getOrdersByUserNumber({String phoneNumber, int pageNumber, CancelToken cancelToken});

  Future<GetOrderResponseModel> getOrder({int orderId, CancelToken cancelToken});
}

class SearchOrdersRemoteDataSourceImplement implements SearchOrdersRemoteDataSource {
  @override
  Future<GetOrderResponseModel> getOrder({int orderId, CancelToken cancelToken}) async {
    Response response = await ApiProvider.sendRequest(
        cancelToken: cancelToken, url: orderApi + orderId.toString(), method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return orderModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<OrderModel>> getOrdersByUserNumber({String phoneNumber, int pageNumber, CancelToken cancelToken}) async {
    Response response = await ApiProvider.sendRequest(
      cancelToken: cancelToken,
      url: getOrdersByUserPhoneNumberApi,
      method: HttpMethods.get,
      queryParameters: {'page': pageNumber, 'phone': phoneNumber},
    );
    try {
      if (response != null) {
        if (response.statusCode == successCode) return ordersModelFromJson(jsonEncode(response.data)).data.data;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/change_order_status_response_model.dart';
import '../models/lock_order_response_model.dart';
import '../models/order_model.dart';
import '../models/orders_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getAllOrders({
    int pageNumber,
    int filterEvaluatedOrders,
    CancelToken cancelToken,
    String toDate,
    String fromDate,
    int orderStatusId,
    String shopperId,
    int warehouseId,
    String supportedCityId,
  });

  Future<List<OrderModel>> getSupplierOrders({int pageNumber, CancelToken cancelToken});

  Future<List<OrderModel>> getShopperOrders({int pageNumber, CancelToken cancelToken});

  Future<ChangeOrderStatusResponseModel> changeOrderStatus({int orderId, int statusId});

  Future<LockOrderResponseModel> lockOrder({int orderId});

  Future<Unit> unlockOrder({int orderId});

  Future<Unit> assignOrderToShopper({int assignedId, int orderId});

  Future<Unit> reAssignOrder({int orderId});

  Future<Unit> updateOrderRating({int orderId, int deliveryRating});
}

class OrdersRemoteDataSourceImplement implements OrdersRemoteDataSource {
  @override
  Future<Unit> reAssignOrder({int orderId}) async {
    Response response =
        await ApiProvider.sendRequest(url: reAssignOrderToShopper + orderId.toString(), method: HttpMethods.put);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> updateOrderRating({int orderId, int deliveryRating}) async {
    Response response = await ApiProvider.sendRequest(
        url: updateOrderRatingApi,
        method: HttpMethods.put,
        body: {'order_id': orderId, 'delivery_rating': deliveryRating});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<OrderModel>> getAllOrders({
    int pageNumber,
    int filterEvaluatedOrders,
    CancelToken cancelToken,
    String toDate,
    String fromDate,
    int orderStatusId,
    String shopperId,
    int warehouseId,
    String supportedCityId,
  }) async {
    Map<String, dynamic> params = {
      'page': pageNumber,
      'filter_evaluated_orders': filterEvaluatedOrders,
      'to_date': toDate,
      'from_date': fromDate,
      'order_status_id': orderStatusId,
      'shopper_id': shopperId,
      'warehouse_id': warehouseId,
      'supported_city_id': supportedCityId
    };
    params.removeWhere((key, value) => value == null);
    Response response = await ApiProvider.sendRequest(
        cancelToken: cancelToken, url: orderApi, method: HttpMethods.get, queryParameters: params);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return ordersModelFromJson(jsonEncode(response.data)).data.data;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> assignOrderToShopper({int assignedId, int orderId}) async {
    Response response = await ApiProvider.sendRequest(
      url: assignOrderToShopperApi,
      method: HttpMethods.post,
      body: {'order_id': orderId.toString(), 'shopper_id': assignedId.toString()},
    );
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<OrderModel>> getSupplierOrders({int pageNumber, CancelToken cancelToken}) async {
    Response response = await ApiProvider.sendRequest(
      cancelToken: cancelToken,
      url: getSupplierOrderApi,
      method: HttpMethods.get,
      queryParameters: {'page': pageNumber},
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

  @override
  Future<List<OrderModel>> getShopperOrders({int pageNumber, CancelToken cancelToken}) async {
    Response response = await ApiProvider.sendRequest(
      cancelToken: cancelToken,
      url: shopperViewsHisOwnOrdersApi,
      method: HttpMethods.get,
      queryParameters: {'page': pageNumber},
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

  @override
  Future<Unit> unlockOrder({int orderId}) async {
    Response response =
        await ApiProvider.sendRequest(url: unlockOrderApi + orderId.toString(), method: HttpMethods.put);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<ChangeOrderStatusResponseModel> changeOrderStatus({int orderId, int statusId}) async {
    Response response = await ApiProvider.sendRequest(
      url: changeOrderStatusApi + orderId.toString(),
      method: HttpMethods.post,
      body: {'order_status_id': statusId.toString()},
    );
    try {
      if (response != null) {
        if (response.statusCode == successCode) return changeStatusModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<LockOrderResponseModel> lockOrder({int orderId}) async {
    Response response = await ApiProvider.sendRequest(url: lockOrderApi + orderId.toString(), method: HttpMethods.put);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return lockOrderModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

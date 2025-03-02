import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/cancel_reason_model.dart';
import '../models/change_order_status_response_model.dart';
import '../models/lock_order_response_model.dart';
import '../models/orders_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrdersPageDataModel> getAllOrders({
    int pageNumber,
    int filterEvaluatedOrders,
    CancelToken cancelToken,
    String toDate,
    String fromDate,
    int orderStatusId,
    String shopperId,
    int warehouseId,
    String supportedCityId,
    int isAssigned,
  });

  Future<OrdersPageDataModel> getSupplierOrders({int orderStatusId, int pageNumber, CancelToken cancelToken});

  Future<OrdersPageDataModel> getShopperOrders({int orderStatusId, int pageNumber, CancelToken cancelToken});

  Future<ChangeOrderStatusResponseModel> changeOrderStatus(
      {int orderId, int statusId, int cancelReasonId, String comment});

  Future<LockOrderResponseModel> lockOrder({int orderId});

  Future<Unit> unlockOrder({int orderId});

  Future<Unit> assignOrderToShopper({int assignedId, int orderId});

  Future<Unit> reAssignOrder({int orderId});

  Future<Unit> updateOrderRating({int orderId, int deliveryRating});

  Future<List<CancelReasonModel>> getCancelReasons();
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
  Future<OrdersPageDataModel> getAllOrders({
    int pageNumber,
    int filterEvaluatedOrders,
    CancelToken cancelToken,
    String toDate,
    String fromDate,
    int orderStatusId,
    String shopperId,
    int warehouseId,
    String supportedCityId,
    int isAssigned,
  }) async {
    Map<String, dynamic> params = {
      'page': pageNumber,
      'filter_evaluated_orders': filterEvaluatedOrders,
      'to_date': toDate,
      'from_date': fromDate,
      'shopper_id': shopperId,
      'warehouse_id': warehouseId,
      'supported_city_id': supportedCityId,
      'is_assigned': isAssigned
    };
    if (orderStatusId == 0) {
      params['order_status_id[0]'] = 1;
      params['order_status_id[1]'] = 2;
      params['order_status_id[2]'] = 3;
      params['order_status_id[3]'] = 4;
    } else {
      params['order_status_id[0]'] = orderStatusId;
    }
    params.removeWhere((key, value) => value == null);
    Response response = await ApiProvider.sendRequest(
        cancelToken: cancelToken, url: orderApi, method: HttpMethods.get, queryParameters: params);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return ordersModelFromJson(jsonEncode(response.data)).data;
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
  Future<OrdersPageDataModel> getSupplierOrders({int orderStatusId, int pageNumber, CancelToken cancelToken}) async {
    Map<String, dynamic> params = {'page': pageNumber};
    if (orderStatusId == 0) {
      params['order_status_id[0]'] = 1;
      params['order_status_id[1]'] = 2;
      params['order_status_id[2]'] = 3;
      params['order_status_id[3]'] = 4;
    } else {
      params['order_status_id[0]'] = orderStatusId;
    }
    params.removeWhere((key, value) => value == null);
    Response response = await ApiProvider.sendRequest(
        cancelToken: cancelToken, url: getSupplierOrderApi, method: HttpMethods.get, queryParameters: params);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return ordersModelFromJson(jsonEncode(response.data)).data;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<OrdersPageDataModel> getShopperOrders({int orderStatusId, int pageNumber, CancelToken cancelToken}) async {
    Map<String, dynamic> params = {'page': pageNumber};
    if (orderStatusId == 0) {
      params['order_status_id'] = [1, 2, 3, 4];
    } else {
      params['order_status_id[0]'] = orderStatusId;
    }
    Response response = await ApiProvider.sendRequest(
        cancelToken: cancelToken, url: shopperViewsHisOwnOrdersApi, method: HttpMethods.get, queryParameters: params);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return ordersModelFromJson(jsonEncode(response.data)).data;
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
  Future<ChangeOrderStatusResponseModel> changeOrderStatus(
      {int orderId, int statusId, int cancelReasonId, String comment}) async {
    Map<String, dynamic> body = {
      'order_status_id': statusId.toString(),
      'order_cancel_reason_id': cancelReasonId,
      'cancel_reason_other': comment
    };
    body.removeWhere((key, value) => value == null);
    Response response = await ApiProvider.sendRequest(
        url: changeOrderStatusApi + orderId.toString(), method: HttpMethods.post, body: body);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return changeStatusModelFromJson(jsonEncode(response.data));
        if (response.statusCode == badRequestError) throw (ServerException(message: response.data['reason']));
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw InternalException(
          message: 'Failed to change order status for orderId=$orderId, statusId=$statusId. Error: ${e.toString()}');
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

  @override
  Future<List<CancelReasonModel>> getCancelReasons() async {
    Response response = await ApiProvider.sendRequest(url: getCancelReasonsApi, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return cancelReasonResponseFromJson(jsonEncode(response.data)).reasons;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

import 'package:call_log/call_log.dart';

import '../../../core/core_importer.dart';
import '../model/change_status_response_model.dart';
import '../model/get_order_model.dart';
import '../model/submit_order_model.dart';

class OrderServices {
  static int orderUnderUpdateIndex = -1;
  static String updateOrderNote = '';
  static String orderUnderUpdateStatusId = '0';
  static String orderUnderUpdateId = '';

  static Future<OrderResponse> updateOrder({SubmitOrderModel submitOrderModel}) async {
    try {
      Map orderMap = submitOrderModel.toJson();
      String orderId;

      orderId = orderUnderUpdateId;

      var response =
          await ApiProvider.sendRequest(url: order + orderId, method: HttpMethods.put, body: jsonEncode(orderMap));

      if (response != null) {
        if (response.data['reason'].toString().contains('discontinued')) {
          return OrderResponse(success: false, reason: 'discontinued');
        }
        return orderResponseFromJson(jsonEncode(response.data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String> cancelOrderService(String orderId) async {
    Map cancelOrderBody = {'order_status_id': 5};
    var response = await ApiProvider.sendRequest(
        url: cancelOrderApi + orderId, method: HttpMethods.post, body: jsonEncode(cancelOrderBody));

    if (response.statusCode == successCode && response.data['success']) {
      return 'true';
    }
    return 'تم قبول طلبك مسبقاً لايمكن إلغاء الطلب حاليا اذا كنت مصراً على إلغاء الطلب يرجى التواصل مع فريق الدعم';
  }

  static Future<LockOrder> lockOrderService(
      {@required String orderId,
      @required int deliveryMethodId,
      @required String supportedCityCost,
      @required String deliveryMethodCost,
      @required String userNote}) async {
    try {
      var response = await ApiProvider.sendRequest(url: lockOrder + orderId, method: HttpMethods.put);
      if (response.data == null) return null;
      if (response.statusCode == successCode && response.data['success']) {
        orderUnderUpdateIndex = StaticVariables.myOrdersList.indexWhere((order) => order.id == int.parse(orderId));
        if (orderUnderUpdateIndex == -1) {
          orderUnderUpdateIndex = 0;
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('orderUnderUpdateId', orderId);

        //! Order Under Update ID !//
        orderUnderUpdateId = orderId;

        //! Order Under Update Delivery Price !//

        StaticVariables.deliveryPrice =
            int.parse(supportedCityCost.split('.')[0]) + int.parse(deliveryMethodCost.split('.')[0]);

        //! Order Under Update Note !//

        updateOrderNote = userNote;

        return lockOrderFromJson(json.encode(response.data));
      }
      return lockOrderFromJson(json.encode(response.data));
    } catch (e) {
      return null;
    }
  }

  static Future<ChangeOrderStatusModel> changeOrderStatusService(String orderId, int statusId) async {
    try {
      var body = {'order_status_id': '$statusId'};
      var response = await ApiProvider.sendRequest(
          url: changeOrderStatus + orderId, method: HttpMethods.post, body: jsonEncode(body));
      if (response != null) {
        if (response.statusCode == successCode) return changeOrderStatusModelFromJson(jsonEncode(response.data));
      }
      return ChangeOrderStatusModel(success: false);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> unlockOrderService(String orderId) async {
    try {
      var response = await ApiProvider.sendRequest(url: unlockOrder + orderId, method: HttpMethods.put);
      if (response != null) return response.statusCode == successCode && response.data['success'];
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getShopperOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: shopperViewsHisOwnOrders, method: HttpMethods.get, queryParameters: {'page': pageNumber});

      StaticVariables.myOrdersList.addAll(ordersFromJson(jsonEncode(response.data))
          .data
          .data
          .where((order) => !StaticVariables.myOrdersList.contains(order)));

      return StaticVariables.myOrdersList;
    } catch (e) {
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getSupplierOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: getSupplierOrder, method: HttpMethods.get, queryParameters: {'page': pageNumber});

      StaticVariables.myOrdersList.addAll(ordersFromJson(jsonEncode(response.data))
          .data
          .data
          .where((order) => !StaticVariables.myOrdersList.contains(order)));

      return StaticVariables.myOrdersList;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> assignOrderToShopperService(String assignedId, String orderId) async {
    Map assignOrderBody = {'order_id': orderId, 'shopper_id': assignedId};

    try {
      var response = await ApiProvider.sendRequest(
          url: assignOrderToShopper, method: HttpMethods.post, body: jsonEncode(assignOrderBody));
      return response.statusCode == successCode && response.data['success'];
    } catch (e) {
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getOrdersByUserNumberService({String phoneNumber, int pageNumber}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: getOrdersByUserPhoneNumber,
          method: HttpMethods.get,
          queryParameters: {'page': pageNumber, 'phone': phoneNumber});

      if (response.statusCode == successCode) {
        if (response.data['success']) return ordersFromJson(jsonEncode(response.data)).data.data;
        return [];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<GetOrderResponse> getOrder({String orderId}) async {
    Response response;
    try {
      response = await ApiProvider.sendRequest(url: order + orderId, method: HttpMethods.get);

      if (response != null) {
        if (response.statusCode == successCode) return getOrderResponseFromJson(jsonEncode(response.data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<CallLogEntry>> callbackDispatcher() async {
    try {
      var now = DateTime.now();
      int from = now.subtract(const Duration(days: 2)).millisecondsSinceEpoch;
      int to = now.subtract(const Duration(days: 0)).millisecondsSinceEpoch;
      final Iterable<CallLogEntry> cLog = await CallLog.query(dateFrom: from, dateTo: to);
      return cLog.toList();
    } on PlatformException catch (e, s) {
      s.toString();
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getAllOrders({int pageNumber = 1, int filterEvaluatedOrders = 0}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: order,
          method: HttpMethods.get,
          queryParameters: {'page': pageNumber, 'filter_evaluated_orders': filterEvaluatedOrders});

      if (response.statusCode == successCode) {
        StaticVariables.allOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;
      }
      return StaticVariables.allOrdersList;
    } catch (e) {
      return null;
    }
  }

  static double gasAllowance({String deliveryDistance, int levelId}) {
    Level orderLevel;
    if (Services.isShopper()) {
      orderLevel = StaticVariables.shopper.level;
    } else {
      orderLevel = StaticVariables.levels.firstWhere((level) => level.id == levelId);
    }
    return (int.parse(orderLevel.pricePerKilo.split('.')[0]) * (int.parse(deliveryDistance) / 1000));
  }
}

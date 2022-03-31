import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services.dart';
import '../../../core/core_importer.dart';
import '../../../models/models_importer.dart';
import '../../../utils/utils_importer.dart';
import '../../../views/cart/services/cart_services.dart';
import '../../../views/loading/LoadingServices.dart';

class OrderServices {
  static String deliverySupportedCityId = '';
  static int orderUnderUpdateIndex = -1;
  static String updateOrderNote = '';

  static String orderUnderUpdateId = '';

  static Future<OrderResponse> updateOrder({String userNotes, bool checkPrices = true}) async {
    String productIds = '';
    String quantities = '';
    String productPrices = '';
    String orderId;

    int purchasePrices = 0;
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productIds = productIds + CartServices.cartProducts[i].id.toString() + ';';
      quantities = quantities + CartServices.cartProducts[i].productCount.toString() + ';';
      purchasePrices = purchasePrices +
          (int.parse(CartServices.cartProducts[i].price.split('.')[0]) *
              CartServices.cartProducts[i].productCount);
      productPrices = productPrices + int.parse(CartServices.cartProducts[i].price.split('.')[0]).toString() + ';';
    }
    String deliveryMethodId = '';
    if (Services.isOperationManager() || Services.isAdmin()) {
      deliveryMethodId = LoadingScreenServices.allOrdersList
          .firstWhere((order) => order.id.toString() == orderUnderUpdateId,
              orElse: () => LoadingScreenServices.phoneOrderList
                  .firstWhere((order) => order.id.toString() == orderUnderUpdateId))
          .deliveryMethodId;
    } else if (Services.isShopper()) {
      deliveryMethodId = LoadingScreenServices.myOrdersList
          .firstWhere((order) => order.id.toString() == orderUnderUpdateId)
          .deliveryMethodId;
    }
    Map orderData = {
      'delivery_method_id': deliveryMethodId,
      'product_ids': productIds.substring(0, productIds.length - 1),
      'quantities': quantities.substring(0, quantities.length - 1),
      'purchase_prices': purchasePrices.toString(),
      'product_prices': productPrices.substring(0, productPrices.length - 1),
      'user_notes': userNotes,
      'check_changed_price_product': checkPrices ? '1' : '0'
    };

    orderId = orderUnderUpdateId;

    try {
      var response = await ApiProvider.sendRequest(
        url: api + order + orderId,
        method: HttpMethods.put,
        body: jsonEncode(orderData),
      );

      if (response.data['reason'].toString().contains('discontinued')) {
        return OrderResponse(success: false, reason: 'discontinued');
      } else {
        var parsedJson = orderResponseFromJson(jsonEncode(response.data));

        return parsedJson;
      }
    } catch (e) {
      Tools.logToConsole('e');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<String> cancelOrderService(String orderId) async {
    Map cancelOrderBody = {
      'order_status_id': 5,
    };
    var response = await ApiProvider.sendRequest(
      url: cancelOrder + orderId,
      method: HttpMethods.post,
      body: jsonEncode(cancelOrderBody),
    );

    if (response.statusCode == successCode && response.data['success']) {
      return 'true';
    } else {
      Tools.logToConsole('------------ ERROR CANCEL ORDER --------------');
      return 'تم قبول طلبك مسبقاً لايمكن إلغاء الطلب حاليا اذا كنت مصراً على إلغاء الطلب يرجى التواصل مع فريق الدعم';
    }
  }

  static Future<LockOrder> lockOrderService(
      {@required String orderId,
      @required int deliveryMethodId,
      @required String supportedCityCost,
      @required String deliveryMethodCost,
      @required String userNote}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: lockOrder + orderId,
        method: HttpMethods.put,
      );
      if (response.data == null) {
        return null;
      }
      if (response.statusCode == successCode && response.data['success']) {
        orderUnderUpdateIndex =
            LoadingScreenServices.myOrdersList.indexWhere((order) => order.id == int.parse(orderId));
        if (orderUnderUpdateIndex == -1) {
          orderUnderUpdateIndex = 0;
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('orderUnderUpdateId', orderId);

        //! Order Under Update ID !//
        orderUnderUpdateId = orderId;

        //! Order Under Update Delivery Price !//

        Services.deliveryPrice =
            int.parse(supportedCityCost.split('.')[0]) + int.parse(deliveryMethodCost.split('.')[0]);

        //! Order Under Update Note !//

        updateOrderNote = userNote;

        return lockOrderFromJson(json.encode(response.data));
      } else {
        return lockOrderFromJson(json.encode(response.data));
      }
    } catch (e) {
      Tools.logToConsole(e.toString());

      return null;
    }
  }

  static Future<bool> changeOrderStatusService(String orderId, int statusId) async {
    try {
      var body = {'order_status_id': '$statusId'};
      var response = await ApiProvider.sendRequest(
        url: changeOrderStatus + orderId,
        method: HttpMethods.post,
        body: jsonEncode(body),
      );

      if (response.statusCode == successCode && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> unlockOrderService(String orderId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: unlockOrder + orderId,
        method: HttpMethods.put,
      );
      if (response.statusCode == successCode && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getDeliveryOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: deliveryViewsHisOwnOrders,
        method: HttpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == successCode) {
        LoadingScreenServices.myOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;

        return LoadingScreenServices.myOrdersList;
      } else {
        return LoadingScreenServices.myOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET getDeliveryOrders ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getShopperOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: shopperViewsHisOwnOrders,
        method: HttpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == successCode) {
        LoadingScreenServices.myOrdersList.addAll(ordersFromJson(jsonEncode(response.data))
            .data
            .data
            .where((order) => !LoadingScreenServices.myOrdersList.contains(order)));

        return LoadingScreenServices.myOrdersList;
      } else {
        return LoadingScreenServices.myOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET ShopperOrders ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getSupplierOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: getSupplierOrder,
        method: HttpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == successCode) {
        LoadingScreenServices.myOrdersList.addAll(ordersFromJson(jsonEncode(response.data))
            .data
            .data
            .where((order) => !LoadingScreenServices.myOrdersList.contains(order)));

        return LoadingScreenServices.myOrdersList;
      } else {
        return LoadingScreenServices.myOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET SUPPLIER ORDERS --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<bool> assignOrderToShopperService(String assignedId, String orderId) async {
    Map assignOrderBody = {
      'order_id': orderId,
      'shopper_id': assignedId,
    };

    try {
      var response = await ApiProvider.sendRequest(
        url: assignOrderToShopper,
        method: HttpMethods.post,
        body: jsonEncode(assignOrderBody),
      );
      if (response.statusCode == successCode && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getOrdersByUserPhoneNumberService(
      {String phoneNumber, int pageNumber}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: getOrdersByUserPhoneNumber,
        method: HttpMethods.get,
        queryParameters: {
          'page': pageNumber,
          'phone': phoneNumber,
        },
      );

      if (response.statusCode == successCode) {
        return ordersFromJson(jsonEncode(response.data)).data.data;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET Phone Orders ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<OrdersOriginalData> getOrder({String orderId}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: api + order + orderId,
        method: HttpMethods.get,
      );

      if (response.statusCode == successCode) {
        // Tools.logToConsole(OrdersOriginalData.fromJson(response.data['order']).products[0].);
        return OrdersOriginalData.fromJson(response.data['order']);
      } else {
        return null;
      }
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
      Tools.logToConsole(e);
      Tools.logToConsole(s);
      return null;
    }
  }
}

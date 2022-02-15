import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../../../models/models_importer.dart';
import '../../../utils/utils_importer.dart';
import '../../../views/cart/services/cart_services.dart';
import '../../../views/deliver_to/deliver_to_view.dart';
import '../../../views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services.dart';

class OrderServices {
  static String deliverySupportedCityId = '';
  static int orderUnderUpdateIndex = -1;
  static String updateOrderNote = '';

  static String orderUnderUpdateId = '';

  static String orderUnderAddressId = '';

  static Future<OrderResponse> submitNewOrder({String userNotes, bool checkPrices = true}) async {
    String productIds = '';
    String quantities = '';
    String productPrices = '';

    int purchasePrices = 0;
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productIds = productIds + CartServices.cartProducts[i].id.toString() + ';';
      quantities = quantities + CartServices.cartProducts[i].productCount.toString() + ';';
      purchasePrices = purchasePrices +
          (int.parse(CartServices.cartProducts[i].price.split('.')[0]) *
              CartServices.cartProducts[i].productCount);
      productPrices = productPrices + int.parse(CartServices.cartProducts[i].price.split('.')[0]).toString() + ';';
    }

    Map orderData = {
      'payment_method_id': '1',
      'delivery_method_id': DeliverToView.selectedIndex.toString(),
      'supported_city_id': deliverySupportedCityId,
      'address_id': OrderServices.orderUnderAddressId,
      'product_ids': productIds.substring(0, productIds.length - 1),
      'quantities': quantities.substring(0, quantities.length - 1),
      'purchase_prices': purchasePrices.toString(),
      'product_prices': productPrices.substring(0, productPrices.length - 1),
      'user_notes': '$userNotes',
      'check_changed_price_product': checkPrices ? '1' : '0'
    };

    try {
      var response = await ApiProvider.sendRequest(
        url: API + ORDER,
        method: httpMethods.post,
        body: jsonEncode(orderData),
      );

      if (response.data['reason'].toString().contains('discontinued')) {
        return new OrderResponse(success: false, reason: 'discontinued');
      } else {
        var parsedJson = orderResponseFromJson(jsonEncode(response.data));

        return parsedJson;
      }
    } catch (e) {
      Tools.logToConsole(e);
      return null;
    }
  }

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

    Map orderData = {
      'delivery_method_id': DeliverToView.selectedIndex.toString(),
      'product_ids': productIds.substring(0, productIds.length - 1),
      'quantities': quantities.substring(0, quantities.length - 1),
      'purchase_prices': purchasePrices.toString(),
      'product_prices': productPrices.substring(0, productPrices.length - 1),
      'user_notes': '$userNotes',
      'check_changed_price_product': checkPrices ? '1' : '0'
    };

    orderId = orderUnderUpdateId;

    try {
      var response = await ApiProvider.sendRequest(
        url: API + ORDER + '/$orderId',
        method: httpMethods.put,
        body: jsonEncode(orderData),
      );

      if (response.data['reason'].toString().contains('discontinued')) {
        return new OrderResponse(success: false, reason: 'discontinued');
      } else {
        var parsedJson = orderResponseFromJson(jsonEncode(response.data));

        return parsedJson;
      }
    } catch (e) {
      Tools.logToConsole(e);
      return null;
    }
  }

  static Future<String> cancelOrder(String orderId) async {
    Map cancelOrderBody = {
      'order_status_id': 5,
    };
    var response = await ApiProvider.sendRequest(
      url: CANCEL_ORDER + orderId,
      method: httpMethods.post,
      body: jsonEncode(cancelOrderBody),
    );

    if (response.statusCode == SUCCESS_CODE && response.data['success']) {
      return 'true';
    } else {
      Tools.logToConsole('------------ ERROR CANCEL ORDER --------------');
      return 'تم قبول طلبك مسبقاً لايمكن إلغاء الطلب حاليا اذا كنت مصراً على إلغاء الطلب يرجى التواصل مع فريق الدعم';
    }
  }

  static Future<bool> rateOrder({String orderId, String userFeedback, double rating}) async {
    Map ratingOrderBody = {
      'user_feedback': userFeedback,
      'user_delivery_rating': rating.toString(),
      'user_price_rating': rating.toString(),
    };
    var response = await ApiProvider.sendRequest(
      url: RATE_ORDER + orderId,
      method: httpMethods.post,
      body: jsonEncode(ratingOrderBody),
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      Tools.logToConsole('------------ ERROR CANCEL ORDER --------------');
      return false;
    }
  }

  static Future<LockOrder> lockOrder(
      {@required String orderId,
      @required int deliveryMethodId,
      @required String supportedCityCost,
      @required String deliveryMethodCost,
      @required String userNote}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: LOCK_ORDER + orderId,
        method: httpMethods.put,
      );
      if (response.data == null) {
        return null;
      }
      if (response.statusCode == SUCCESS_CODE && response.data['success']) {
        orderUnderUpdateIndex =
            LoadingScreenServices.myOrdersList.indexWhere((order) => order.id == int.parse(orderId));
        if (orderUnderUpdateIndex == -1) {
          orderUnderUpdateIndex = 0;
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('orderUnderUpdateId', orderId);

        //! Order Under Update ID !//
        orderUnderUpdateId = orderId;

        //! Order Under Update delivery Method !//
        DeliverToView.selectedIndex = deliveryMethodId;

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

  static Future<bool> changeOrderStatus(String orderId, int statusId) async {
    try {
      var body = {'order_status_id': '$statusId'};
      var response = await ApiProvider.sendRequest(
        url: CHANGE_ORDER_STATUS + '$orderId',
        method: httpMethods.post,
        body: jsonEncode(body),
      );

      if (response.statusCode == SUCCESS_CODE && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> unlockOrder(String orderId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: UNLOCK_ORDER + orderId,
        method: httpMethods.put,
      );
      if (response.statusCode == SUCCESS_CODE && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<OrdersOriginalData>> getOrdersNotAssignedToDeliveries({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: ORDERS_NOT_ASSIGNED_TO_DELIVERIES,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.notAssignedOrdersList.addAll(ordersFromJson(jsonEncode(response.data))
            .data
            .data
            .where((order) => !LoadingScreenServices.notAssignedOrdersList.contains(order)));

        return LoadingScreenServices.notAssignedOrdersList;
      } else {
        return LoadingScreenServices.notAssignedOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET NotAssignedToDeliveries ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getOrdersAssignedToDeliveries({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_ORDERS_ASSIGNED_TO_DELIVERIES,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.deliveriesAssignedOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;

        return LoadingScreenServices.deliveriesAssignedOrdersList;
      } else {
        return LoadingScreenServices.deliveriesAssignedOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET NotAssignedToDeliveries ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getOrdersAssignedToShoppers({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_ORDERS_ASSIGNED_TO_SHOPPERS,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.shoppersAssignedOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;

        return LoadingScreenServices.shoppersAssignedOrdersList;
      } else {
        return LoadingScreenServices.shoppersAssignedOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET NotAssignedToDeliveries ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getDeliveryOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: DELIVERY_VIEWS_HIS_OWN_ORDERS,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
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

  static Future<List<OrdersOriginalData>> getOrdersNotAssignedToShoppers({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: GET_ORDERS_NOT_ASSIGNED_TO_SHOPPERS,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
        LoadingScreenServices.notAssignedOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;

        return LoadingScreenServices.notAssignedOrdersList;
      } else {
        return LoadingScreenServices.notAssignedOrdersList;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET NotAssignedToShoppers ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<OrdersOriginalData>> getShopperOrders({int pageNumber = 1}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: SHOPPER_VIEWS_HIS_OWN_ORDERS,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
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
        url: GET_SUPPLIER_ORDER,
        method: httpMethods.get,
        queryParameters: {'page': pageNumber},
      );

      if (response.statusCode == SUCCESS_CODE) {
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

  static Future<bool> assignOrder(String orderId) async {
    String url;
    if (Services.isDelivery())
      url = ASSIGN_DELIVERY_ORDER_HIMSELF;
    else
      url = ASSIGN_SHOPPER_ORDER_HIMSELF;
    try {
      var response = await ApiProvider.sendRequest(
        url: url + orderId,
        method: httpMethods.put,
      );

      if (response.statusCode == SUCCESS_CODE && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole('------------ ERROR GET ShopperOrders ORDER --------------');
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<bool> assignOrderToShopper(String assignedId, String orderId) async {
    Map assignOrderBody = {
      'order_id': orderId,
      'shopper_id': assignedId,
    };

    try {
      var response = await ApiProvider.sendRequest(
        url: ASSIGN_ORDER_TO_SHOPPER,
        method: httpMethods.post,
        body: jsonEncode(assignOrderBody),
      );
      if (response.statusCode == SUCCESS_CODE && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> assignOrderToDelivery(String assignedId, String orderId) async {
    Map assignOrderBody = {
      'order_id': orderId,
      'delivery_id': assignedId,
    };

    try {
      var response = await ApiProvider.sendRequest(
        url: ASSIGN_ORDER_TO_DELIVERY,
        method: httpMethods.post,
        body: jsonEncode(assignOrderBody),
      );
      if (response.statusCode == SUCCESS_CODE && response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

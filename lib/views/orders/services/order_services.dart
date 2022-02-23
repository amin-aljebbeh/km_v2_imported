import 'dart:convert';

import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/orders_response.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/deliver_to/delivery_method.dart';
import 'package:kammun_app/views/deliver_to/services/delivery_method_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services.dart';

class OrderServices {
  static String deliverySupportedCityId = "";
  static int orderUnderUpdateIndex = -1;
  static String updateOrderNote = "";

  static Future<OrderResponse> submitNewOrder({String userNotes}) async {
    String productIds = "";
    String quantities = "";
    String productPrices = "";

    int purchasePrices = 0;
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productIds = productIds + CartServices.cartProducts[i].id.toString() + ";";
      quantities = quantities + CartServices.cartProducts[i].productCount.toString() + ";";
      purchasePrices = purchasePrices +
          (int.parse(CartServices.cartProducts[i].price.split(".")[0]) *
              CartServices.cartProducts[i].productCount);
      productPrices = productPrices + int.parse(CartServices.cartProducts[i].price.split(".")[0]).toString() + ";";
    }

    Map orderData = {
      "payment_method_id": "1",
      "delivery_method_id":
          DeliveryMethodServices.deliveryMethodsList[(DeliveryMethodView.selectedDeliveryIndex)].id.toString(),
      "supported_city_id": deliverySupportedCityId,
      "address_id": LoadingScreenServices.userAddress[DeliverToView.selectedIndex].id,
      "product_ids": productIds.substring(0, productIds.length - 1),
      "quantities": quantities.substring(0, quantities.length - 1),
      "purchase_prices": purchasePrices.toString(),
      "product_prices": productPrices.substring(0, productPrices.length - 1),
      "user_notes": "$userNotes"
    };

    var response;
    try {
      response = await ApiProvider.sendRequest(url: ORDER, method: httpMethods.post, body: jsonEncode(orderData));

      if (response.data["reason"].toString().contains("discontinued")) {
        return new OrderResponse(success: false, reason: "discontinued");
      } else {
        var parsedJson = orderResponseFromJson(jsonEncode(response.data));

        return parsedJson;
      }
    } catch (e) {
      Tools.logToConsole(response.toString());
      return null;
    }
  }

  static Future<OrderResponse> updateOrder({String userNotes}) async {
    String productIds = "";
    String quantities = "";
    String productPrices = "";
    String orderId;

    int purchasePrices = 0;
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productIds = productIds + CartServices.cartProducts[i].id.toString() + ";";
      quantities = quantities + CartServices.cartProducts[i].productCount.toString() + ";";
      purchasePrices = purchasePrices +
          (int.parse(CartServices.cartProducts[i].price.split(".")[0]) *
              CartServices.cartProducts[i].productCount);
      productPrices = productPrices + int.parse(CartServices.cartProducts[i].price.split(".")[0]).toString() + ";";
    }

    Map orderData = {
      "delivery_method_id":
          DeliveryMethodServices.deliveryMethodsList[(DeliveryMethodView.selectedDeliveryIndex)].id,
      "product_ids": productIds.substring(0, productIds.length - 1),
      "quantities": quantities.substring(0, quantities.length - 1),
      "purchase_prices": purchasePrices.toString(),
      "product_prices": productPrices.substring(0, productPrices.length - 1),
      "user_notes": "$userNotes"
    };
    orderId = LoadingScreenServices.myOrdersList[OrderServices.orderUnderUpdateIndex].id.toString();

    try {
      var response = await ApiProvider.sendRequest(
          url: ORDER + "/$orderId", method: httpMethods.put, body: jsonEncode(orderData));

      if (response.data["reason"].toString().contains("discontinued")) {
        return new OrderResponse(success: false, reason: "discontinued");
      } else {
        var parsedJson = orderResponseFromJson(jsonEncode(response.data));

        return parsedJson;
      }
    } catch (e) {
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

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return "true";
    } else {
      await Services.getMyOrders();
      return "تم قبول طلبك مسبقاً لايمكن إلغاء الطلب حاليا اذا كنت مصراً على إلغاء الطلب يرجى التواصل مع فريق الدعم";
    }
  }

  static Future<bool> rateOrder({String orderId, String userFeedback, double rating}) async {
    Map ratingOrderBody = {
      'user_feedback': userFeedback,
      "user_delivery_rating": rating.toString(),
      "user_price_rating": rating.toString(),
    };
    var response = await ApiProvider.sendRequest(
      url: RATE_ORDER + orderId,
      method: httpMethods.post,
      body: jsonEncode(ratingOrderBody),
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> lockOrder(String orderId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: LOCK_ORDER + orderId,
        method: httpMethods.put,
      );
      if (response.data == null) {
        return "null";
      }
      if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
        orderUnderUpdateIndex =
            LoadingScreenServices.myOrdersList.indexWhere((order) => order.id == int.parse(orderId));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("orderUnderUpdateId", orderId);

        DeliverToView.selectedIndex = LoadingScreenServices.userAddress.indexWhere((address) =>
            address.id == int.parse(LoadingScreenServices.myOrdersList[orderUnderUpdateIndex].addressId));

        updateOrderNote = LoadingScreenServices.myOrdersList[orderUnderUpdateIndex].userNotes;

        return "true";
      } else {
        if (response.data["reason"].toString().contains("admin")) {
          return "admin";
        } else if (response.data["reason"].toString().contains("Another")) {
          return "Another";
        } else {
          return "false";
        }
      }
    } catch (e) {
      return "null";
    }
  }
}

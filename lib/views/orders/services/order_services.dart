import 'dart:convert';

import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/orders_response.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/deliver_to/delivery_method.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services.dart';

class OrderServices {
  static String delivery_supported_City_id = "";
  static int orderUnderUpdateIndex = -1;
  static String updateOrderNote = "";

  static Future<OrderResponse> submitNewOrder({String userNotes}) async {
    String productIds = "";
    String quantities = "";
    String productPrices = "";

    int purchasePrices = 0;
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productIds =
          productIds + CartServices.cartProducts[i].id.toString() + ";";
      quantities = quantities +
          CartServices.cartProducts[i].productCount.toString() +
          ";";
      purchasePrices = purchasePrices +
          (int.parse(CartServices.cartProducts[i].warehouses[0].pivot.price
                  .split(".")[0]) *
              CartServices.cartProducts[i].productCount);
      productPrices = productPrices +
          int.parse(CartServices.cartProducts[i].warehouses[0].pivot.price
                  .split(".")[0])
              .toString() +
          ";";
    }

    Map orderData = {
      "payment_method_id": "1",
      "delivery_method_id": LoadingScreenServices
          .deliveryMethodsList[(DeliveryMethodView.selectedDeliveryIndex)].id
          .toString(),
      "supported_city_id": delivery_supported_City_id,
      "address_id":
          LoadingScreenServices.userAddress[DeliverToView.selectedIndex].id,
      "product_ids": productIds.substring(0, productIds.length - 1),
      "quantities": quantities.substring(0, quantities.length - 1),
      "purchase_prices": purchasePrices.toString(),
      "product_prices": productPrices.substring(0, productPrices.length - 1),
      "user_notes": "$userNotes"
    };

    try {
      var response = await ApiProvider.sendRequest(
          url: ORDER, method: httpMethods.post, body: jsonEncode(orderData));

      var barsedJson = orderResponseFromJson(jsonEncode(response.data));

      return barsedJson;
    } catch (e) {
      print(e);
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
      productIds =
          productIds + CartServices.cartProducts[i].id.toString() + ";";
      quantities = quantities +
          CartServices.cartProducts[i].productCount.toString() +
          ";";
      purchasePrices = purchasePrices +
          (int.parse(CartServices.cartProducts[i].warehouses[0].pivot.price
                  .split(".")[0]) *
              CartServices.cartProducts[i].productCount);
      productPrices = productPrices +
          int.parse(CartServices.cartProducts[i].warehouses[0].pivot.price
                  .split(".")[0])
              .toString() +
          ";";
    }

    Map orderData = {
      "delivery_method_id": LoadingScreenServices
          .deliveryMethodsList[(DeliveryMethodView.selectedDeliveryIndex)].id,
      "product_ids": productIds.substring(0, productIds.length - 1),
      "quantities": quantities.substring(0, quantities.length - 1),
      "purchase_prices": purchasePrices.toString(),
      "product_prices": productPrices.substring(0, productPrices.length - 1),
      "user_notes": "$userNotes"
    };
    orderId = LoadingScreenServices
        .myOrdersList[OrderServices.orderUnderUpdateIndex].id
        .toString();

    try {
      var response = await ApiProvider.sendRequest(
          url: ORDER + "/$orderId",
          method: httpMethods.put,
          body: jsonEncode(orderData));

      var barsedJson = orderResponseFromJson(jsonEncode(response.data));

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          CartServices.cartProducts.clear();
          orderUnderUpdateIndex = -1;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("orderUnderUpdateId", "-1");

          return barsedJson;

          //return response.data["data"]["message"];
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> cancelOrder(String orderId) async {
    // print("------------------ CANCEL ORDER  --------------------");

    Map cancelOrderBody = {
      'order_status_id': 5,
    };
    var response = await ApiProvider.sendRequest(
      url: ORDER_URL + orderId,
      method: httpMethods.put,
      body: jsonEncode(cancelOrderBody),
    );

    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      print("------------ ERROR CANCEL ORDER --------------");
      return false;
    }
  }

  static Future<bool> lockOrder(String orderId) async {
    // print("------------------ CANCEL ORDER  --------------------");

    var response = await ApiProvider.sendRequest(
      url: LOCK_ORDER + orderId,
      method: httpMethods.put,
    );
    if (response.statusCode == SUCCESS_CODE) {
      orderUnderUpdateIndex = LoadingScreenServices.myOrdersList
          .indexWhere((order) => order.id == int.parse(orderId));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("orderUnderUpdateId", orderId);

      DeliverToView.selectedIndex = LoadingScreenServices.userAddress
          .indexWhere((address) =>
              address.id ==
              int.parse(LoadingScreenServices
                  .myOrdersList[orderUnderUpdateIndex].addressId));

      Services.delivery_Price = int.parse(LoadingScreenServices
          .myOrdersList[orderUnderUpdateIndex].supportedCityCost
          .split(".")[0]);

      updateOrderNote =
          LoadingScreenServices.myOrdersList[orderUnderUpdateIndex].userNotes;

      return true;
    } else {
      print("------------ ERROR CANCEL ORDER --------------");
      return false;
    }
  }
}

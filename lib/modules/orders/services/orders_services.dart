import '../../../core/core_importer.dart';
import '../../order/models/submit_order_model.dart';

class OrdersServices {
  static Future<List<OrdersOriginalData>> getMyOrders() async {
    try {
      var response = await ApiProvider.sendRequest(url: getUserOrder, method: HttpMethods.get);
      if (response.statusCode == successCode) {
        return getOrdersModelFromJson(jsonEncode(response.data)).orders;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> rateOrderService({String orderId, String userFeedback, double rating}) async {
    try {
      Map ratingOrderBody = {
        'user_feedback': userFeedback,
        'user_delivery_rating': rating.toString(),
        'user_price_rating': rating.toString(),
      };
      var response = await ApiProvider.sendRequest(
          url: rateOrder + orderId, method: HttpMethods.post, body: jsonEncode(ratingOrderBody));

      if (response.statusCode == successCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> cancelOrderService({String orderId}) async {
    try {
      Map cancelOrderBody = {'order_status_id': 6};
      var response = await ApiProvider.sendRequest(
          url: cancelOrder + orderId, method: HttpMethods.post, body: jsonEncode(cancelOrderBody));

      if (response != null) {
        if (response.statusCode == successCode && response.data['success']) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<String> lockOrderService({String orderId}) async {
    try {
      var response = await ApiProvider.sendRequest(url: lockOrder + orderId, method: HttpMethods.put);
      if (response.data == null) {
        return 'null';
      }
      if (response.statusCode == successCode && response.data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('orderUnderUpdateId', orderId);

        return 'true';
      } else {
        if (response.data['reason'].toString().contains('admin')) {
          return 'admin';
        } else if (response.data['reason'].toString().contains('Another')) {
          return 'Another';
        } else {
          return 'false';
        }
      }
    } catch (e) {
      return 'null';
    }
  }

  static Future<OrderResponse> updateOrder({SubmitOrderModel submitOrderModel, String orderId}) async {
    try {
      Map orderMap = submitOrderModel.toJson();
      orderMap.remove('coupon_code');
      orderMap.remove('address_id');
      orderMap.remove('supported_city_id');
      orderMap.remove('payment_method_id');
      orderMap.remove('use_wallet');
      orderMap.remove('delivery_method_id');
      var response =
          await ApiProvider.sendRequest(url: order + orderId, method: HttpMethods.put, body: jsonEncode(orderMap));

      if (response != null) {
        if (response.data['reason'].toString().contains('discontinued')) {
          return OrderResponse(success: false, reason: 'discontinued');
        } else {
          var parsedJson = orderResponseFromJson(jsonEncode(response.data));

          return parsedJson;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

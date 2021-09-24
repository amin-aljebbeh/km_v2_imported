import 'dart:convert';
import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';

class OrderDetailsServices {
  static Future<bool> updateOrder(
      {String orderId,
      String updateKey,
      String updateValue,
      String productId}) async {
    Map updateOrderBody = {updateKey: updateValue, "product_id": productId};
    var response = await ApiProvider.sendRequest(
      url: UPDATE_ORDER_PRODUCTS + orderId,
      method: httpMethods.put,
      body: jsonEncode(updateOrderBody),
    );
    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return false;
    }
  }
}

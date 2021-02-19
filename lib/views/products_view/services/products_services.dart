import 'dart:convert';

import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';

class ProductsServices {
  static Future<bool> updateProductsDetails(
      {String bodyKey, String value, String productId}) async {
    var body = {bodyKey: value};

    var response = await ApiProvider.sendRequest(
        url: GET_PRODUCT + productId,
        method: httpMethods.put,
        body: jsonEncode(body));

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole(response.data);
      return true;
    } else {
      return false;
    }
  }
}

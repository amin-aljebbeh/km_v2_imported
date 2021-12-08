import 'dart:convert';

import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';

import '../../../Services.dart';

class AddedProductsServices {
  static Future<List<ProductData>> getAddedProductsToWarehouse() async {
    var response = await ApiProvider.sendRequest(
      url: GET_ADDED_PRODUCTS_TO_WAREHOUSE,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<List<ProductData>> getNotAddedProductsToWarehouse() async {
    var response = await ApiProvider.sendRequest(
      url: GET_NOT_ADDED_PRODUCTS_TO_WAREHOUSE,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> unAttachProductsToSubWarehouse({
    String productsId,
    String subWarehouse,
  }) async {
    var response = await ApiProvider.sendRequest(
        url: UN_ATTACH_PRODUCTS_TO_SUB_WAREHOUSE + productsId,
        method: httpMethods.delete,
        body: jsonEncode({"sub_warehouse_id": int.parse(subWarehouse)}));

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      Tools.logToConsole(response.data);

      return false;
    }
  }

  static Future<bool> attachProductsToSubWarehouse({
    dynamic fullRequestBody,
  }) async {
    var response = await ApiProvider.sendRequest(
        url: ATTACH_PRODUCTS_TO_SUB_WAREHOUSE,
        method: httpMethods.post,
        body: jsonEncode(fullRequestBody));

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      Tools.logToConsole("Product Attached to products successfully");
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      Tools.logToConsole(response.data);

      return false;
    }
  }
}

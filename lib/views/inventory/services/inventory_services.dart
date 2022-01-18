import 'dart:convert';
import 'package:kammun_app/core/api/api_importer.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/inventory/model/filtered_products_model.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/models/login_admin_model.dart';

import '../../../Services.dart';

class InventoryServices {
  static Future<bool> getInventoryProducts() async {
    var response = await ApiProvider.sendRequest(
      url: GET_INVENTORY_PRODUCTS,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return false;
    }
  }

  static Future<List<SubWarehouse>> getSubWarehoused({String adminId}) async {
    var response = await ApiProvider.sendRequest(
      url: GET_ADMIN_INFO + adminId,
      method: httpMethods.get,
    );

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      final result = adminLoginResponseFromJson(jsonEncode(response.data));

      if (result.data.roles.length > 0) {
        Services.roles = result.data.roles;
        if (result.data.shopper != null) {
          Services.shopper = result.data.shopper;
          Services.shopper.level = await Services.getLevel(result.data.shopper.levelId.toString());
        }
      }
      LoadingScreenServices.name = result.data.name;
      LoadingScreenServices.userName = result.data.username;
      LoadingScreenServices.phoneNumber = result.data.phone;
      return result.data.subWarehouses;
    } else {
      Tools.logToConsole("------------ ERROR Get Sup warehouse --------------");
      return null;
    }
  }

  static Future<List<ProductData>> getSubWarehouseProducts({String subWarehouseId}) async {
    var response = await ApiProvider.sendRequest(
      url: GET_SUB_WAREHOUSE_PRODUCTS + subWarehouseId,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      final result = syncCartFromJson(jsonEncode(response.data["data"]["products"]));

      return result;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<List<ProductData>> getFilteredProducts({int page, int filterIndex, String number}) async {
    Map<String, dynamic> params = {StringUtils.productFilterParams[filterIndex]: number, 'page': page};
    var response = await ApiProvider.sendRequest(
        url: StringUtils.productFilterUrls[filterIndex], method: httpMethods.get, queryParameters: params);
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      final result = filteredProductsModelFromJson(jsonEncode(response.data)).data.products;

      return result;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> updatePriceRateThreshold(String threshold) async {
    Map thresholdMap = {'threshold': threshold};
    try {
      var response = await ApiProvider.sendRequest(
          url: UPDATE_PRICE_RATE_THRESHOLD, method: httpMethods.put, body: jsonEncode(thresholdMap));

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        Tools.logToConsole("------------ ERROR UPDATE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

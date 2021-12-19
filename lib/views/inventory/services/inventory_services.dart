import 'dart:convert';

import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/models/sub_warehouse_model.dart';
import 'package:kammun_app/utils/tools.dart';
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
    Tools.logToConsole("ADMINIDIS: $adminId");
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
          // await Services.getShopper(result.data.shopper.id.toString());
        }
      }
      LoadingScreenServices.name = result.data.name;
      LoadingScreenServices.userName = result.data.username;
      LoadingScreenServices.phoneNumber = result.data.phone;
      return result.data.subWarehouses;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<List<ProductData>> getSubWarehouseProducts(
      {String subWarehouseId}) async {
    var response = await ApiProvider.sendRequest(
      url: GET_SUB_WAREHOUSE_PRODUCTS + subWarehouseId,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      final result =
          syncCartFromJson(jsonEncode(response.data["data"]["products"]));

      return result;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }
}

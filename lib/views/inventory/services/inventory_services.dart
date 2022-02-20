import 'dart:convert';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/inventory/model/inventory_model_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/models/login_admin_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kammun_app/views/loading/Loading.dart';
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

  static Future<List<ProductData>> getFilteredProducts(
      {int page, int filterIndex, String number, int biggerThan}) async {
    Map<String, dynamic> params = {
      StringUtils.productFilterParams[filterIndex]: number,
      'page': page,
      'biggar_than': biggerThan
    };
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

  static Future<PriceFileProductModel> fromFileChangedPriceProducts({String subWarehouseId, File file}) async {
    try {
      Tools.logToConsole('intro 1');
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(BASE_URL + IMPORT_PRODUCT_PRICES_IN_WAREHOUSE));
      request.fields.addAll({'sub_warehouse_id': '$subWarehouseId'});
      request.files.add(await http.MultipartFile.fromPath('file', '${file.path}'));
      request.headers.addAll(headers);
      var response = await request.send();
      Tools.logToConsole('sent 1');
      if (response.statusCode == 200) {
        PriceFileProductModel price = priceFileProductModelFromJson(await response.stream.bytesToString());
        Tools.logToConsole('done 1');
        return price;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      Tools.logToConsole('message 1');
      return null;
    }
  }

  static Future<InventoryFileProductModel> fromFileChangedStatusProducts(
      {String subWarehouseId, File file}) async {
    http.StreamedResponse response;
    try {
      Tools.logToConsole('intro 2');
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(BASE_URL + IMPORT_PRODUCT_ACTIVATION_IN_WAREHOUSE));
      request.fields.addAll({'sub_warehouse_id': '$subWarehouseId'});
      request.files.add(await http.MultipartFile.fromPath('file', '${file.path}'));
      request.headers.addAll(headers);
      response = await request.send();
      Tools.logToConsole('sent 2');
      if (response.statusCode == 200) {
        InventoryFileProductModel price =
            inventoryFileProductModelProductsFromJson(await response.stream.bytesToString());
        Tools.logToConsole('done 2');
        return price;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole(response.reasonPhrase);
      Tools.logToConsole(e.toString());
      Tools.logToConsole('message 2');
      return null;
    }
  }
}

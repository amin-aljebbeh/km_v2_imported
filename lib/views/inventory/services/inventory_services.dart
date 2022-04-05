import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/inventory/model/inventory_model_importer.dart';
import 'package:kammun_app/views/loading/loading.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/login/models/login_admin_model.dart';

import '../../../service.dart';

class InventoryServices {
  static Future<bool> getInventoryProductsService() async {
    var response = await ApiProvider.sendRequest(
      url: getInventoryProducts,
      method: HttpMethods.get,
    );

    if (response.statusCode == successCode && response.data["success"]) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return false;
    }
  }

  static Future<List<SubWarehouse>> getSubWarehoused({String adminId}) async {
    var response = await ApiProvider.sendRequest(
      url: getAdminInfo + adminId,
      method: HttpMethods.get,
    );

    if (response.statusCode == successCode && response.data["success"]) {
      final result = adminLoginResponseFromJson(jsonEncode(response.data));

      if (result.data.roles.isNotEmpty) {
        Services.roles = result.data.roles;
        if (result.data.shopper != null) {
          Services.shopper = result.data.shopper;
          Services.shopper.level = await Services.getLevelService(result.data.shopper.levelId.toString());
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

  static Future<List<ProductData>> getSubWarehouseProductsService({String subWarehouseId}) async {
    var response = await ApiProvider.sendRequest(
      url: getSubWarehouseProducts + subWarehouseId,
      method: HttpMethods.get,
    );
    if (response.statusCode == successCode && response.data["success"]) {
      final result = syncCartFromJson(jsonEncode(response.data["data"]["products"]));

      return result;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<FilterPagination> getFilteredProducts(
      {int page,
      int filterIndex,
      String number = '0',
      int biggerThan = 0,
      String fromDate = ' ',
      String toDate = ' '}) async {
    Map<String, dynamic> params;
    if (filterIndex < 3) {
      params = {StringUtils.productFilterParams[filterIndex]: number, 'page': page, 'biggar_than': biggerThan};
    } else {
      params = {'page': page, "from_date": fromDate, "to_date": toDate};
    }
    var response = await ApiProvider.sendRequest(
      url: StringUtils.productFilterUrls[filterIndex],
      method: HttpMethods.get,
      queryParameters: params,
    );
    if (response.statusCode == successCode && response.data["success"]) {
      final result = filteredProductsModelFromJson(jsonEncode(response.data)).data;

      return result;
    } else {
      Tools.logToConsole("--------------------");
      return null;
    }
  }

  static Future<bool> updatePriceRateThresholdService(String threshold) async {
    Map thresholdMap = {'threshold': threshold};
    try {
      var response = await ApiProvider.sendRequest(
          url: updatePriceRateThreshold, method: HttpMethods.put, body: jsonEncode(thresholdMap));

      if (response.statusCode == successCode) {
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
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + importProductPricesInWareHouse));
      request.fields.addAll({'sub_warehouse_id': subWarehouseId});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      var response = await request.send();
      if (response.statusCode == 200) {
        PriceFileProductModel price = priceFileProductModelFromJson(await response.stream.bytesToString());
        return price;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<InventoryFileProductModel> fromFileChangedStatusProducts(
      {String subWarehouseId, File file}) async {
    http.StreamedResponse response;
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + importProductActivationInWarehouse));
      request.fields.addAll({'sub_warehouse_id': subWarehouseId});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      response = await request.send();
      if (response.statusCode == 200) {
        InventoryFileProductModel price =
            inventoryFileProductModelProductsFromJson(await response.stream.bytesToString());
        return price;
      } else {
        return null;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return null;
    }
  }
}

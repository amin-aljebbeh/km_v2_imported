import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/views/inventory/model/inventory_model_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/login/models/login_admin_model.dart';

class InventoryServices {
  static Future<List<SubWarehouse>> getAdmin({String adminId}) async {
    var response = await ApiProvider.sendRequest(url: admin + adminId, method: HttpMethods.get);

    if (response.statusCode == successCode && response.data['success']) {
      final result = adminLoginResponseFromJson(jsonEncode(response.data));

      if (result.data.roles.isNotEmpty) {
        Services.roles = result.data.roles;
        if (result.data.shopper != null) {
          Services.shopper = result.data.shopper;
          Services.shopper.level = await Services.getLevelService(result.data.shopper.levelId.toString());
        }
      }
      LoadingScreenServices.admin = result.data;
      return result.data.subWarehouses;
    }
    return null;
  }

  static Future<List<ProductData>> getSubWarehouseProductsService({String subWarehouseId}) async {
    var response = await ApiProvider.sendRequest(url: subWarehouse + subWarehouseId, method: HttpMethods.get);
    if (response.statusCode == successCode && response.data['success']) {
      final result = syncCartFromJson(jsonEncode(response.data['data']['products']));

      return result;
    } else {
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
      params = {productFilterParams[filterIndex]: number, 'page': page, 'biggar_than': biggerThan};
    } else {
      params = {'page': page, 'from_date': fromDate, 'to_date': toDate};
    }
    var response = await ApiProvider.sendRequest(
        url: productFilterUrls[filterIndex], method: HttpMethods.get, queryParameters: params);
    if (response.statusCode == successCode && response.data['success']) {
      final result = filteredProductsModelFromJson(jsonEncode(response.data)).data;

      return result;
    }
    return null;
  }

  static Future<bool> updatePriceRateThresholdService(String threshold) async {
    Map thresholdMap = {'threshold': threshold};
    try {
      var response = await ApiProvider.sendRequest(
          url: updatePriceRateThreshold, method: HttpMethods.put, body: jsonEncode(thresholdMap));

      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<PriceFileProductModel> fromFileChangedPriceProducts({String subWarehouseId, File file}) async {
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductPricesInWareHouse));
      request.fields.addAll({'sub_warehouse_id': subWarehouseId});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      var response = await request.send();
      if (response.statusCode == 200) {
        PriceFileProductModel price = priceFileProductModelFromJson(await response.stream.bytesToString());
        return price;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<InventoryFileProductModel> fromFileChangedStatusProducts({String subWarehouseId, File file}) async {
    http.StreamedResponse response;
    try {
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductActivationInWarehouse));
      request.fields.addAll({'sub_warehouse_id': subWarehouseId});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      response = await request.send();
      if (response.statusCode == 200) {
        InventoryFileProductModel price =
            inventoryFileProductModelProductsFromJson(await response.stream.bytesToString());
        return price;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

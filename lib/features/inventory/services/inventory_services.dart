import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory/model/inventory_model_importer.dart';

class InventoryServices {
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
      Tools.logToConsole(baseUrl + '/api/' + importProductPricesInWareHouse);
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductPricesInWareHouse));
      request.fields.addAll({'sub_warehouse_id': subWarehouseId});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      var response = await request.send();
      Tools.logToConsole(response);
      if (response.statusCode == 200) {
        Tools.logToConsole(response.stream.bytesToString());
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
      Tools.logToConsole(baseUrl + '/api/' + importProductActivationInWarehouse);
      var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductActivationInWarehouse));
      request.fields.addAll({'sub_warehouse_id': subWarehouseId});
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      response = await request.send();
      Tools.logToConsole(response);
      if (response.statusCode == 200) {
        Tools.logToConsole(response.stream.bytesToString());
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

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core_importer.dart';
import '../models/inventory_file_product_model.dart';
import '../models/price_file_product_model.dart';

abstract class SubWarehouseManagerRemoteDataSource {
  Future<PriceFileProductModel> importProductPricesInWarehouse({String subWarehouseId, File file});

  Future<Unit> updatePriceRateThreshold({String threshold});

  Future<InventoryFileProductModel> importProductActivationInWarehouse({String subWarehouseId, File file});
}

class ExcelInventoryRemoteDataSourceImplement implements SubWarehouseManagerRemoteDataSource {
  @override
  Future<InventoryFileProductModel> importProductActivationInWarehouse({String subWarehouseId, File file}) async {
    http.StreamedResponse response;
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductActivationInWarehouseApi));
    request.fields.addAll({'sub_warehouse_id': subWarehouseId});
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.headers.addAll(headers);
    response = await request.send();
    try {
      // Tools.logToConsole(await response.stream.bytesToString());
      if (response.statusCode == successCode) {
        InventoryFileProductModel price =
            inventoryFileProductModelProductsFromJson(await response.stream.bytesToString());
        return price;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<PriceFileProductModel> importProductPricesInWarehouse({String subWarehouseId, File file}) async {
    http.StreamedResponse response;
    Tools.logToConsole(baseUrl + '/api/' + importProductPricesInWareHouseApi);
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductPricesInWareHouseApi));
    request.fields.addAll({'sub_warehouse_id': subWarehouseId});
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.headers.addAll(headers);
    response = await request.send();
    Tools.logToConsole('response');
    Tools.logToConsole(response);
    try {
      // Tools.logToConsole(await response.stream.bytesToString());
      if (response.statusCode == successCode) {
        PriceFileProductModel price = priceFileProductModelFromJson(await response.stream.bytesToString());
        return price;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> updatePriceRateThreshold({String threshold}) async {
    Response response = await ApiProvider.sendRequest(
        url: updatePriceRateThresholdApi, method: HttpMethods.put, body: jsonEncode({'threshold': threshold}));
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

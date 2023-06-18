import 'package:http/http.dart' as http;

import '../../../../core/core_importer.dart';
import '../models/inventory_file_product_model.dart';
import '../models/price_file_product_model.dart';

abstract class ExcelInventoryRemoteDataSource {
  Future<PriceFileProductModel> importProductPricesInWarehouse({String subWarehouseId, File file});

  Future<InventoryFileProductModel> importProductActivationInWarehouse({String subWarehouseId, File file});
}

class ExcelInventoryRemoteDataSourceImplement implements ExcelInventoryRemoteDataSource {
  @override
  Future<InventoryFileProductModel> importProductActivationInWarehouse({String subWarehouseId, File file}) async {
    http.StreamedResponse response;
    Tools.logToConsole(baseUrl + '/api/' + importProductActivationInWarehouseApi);
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + importProductActivationInWarehouseApi));
    request.fields.addAll({'sub_warehouse_id': subWarehouseId});
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.headers.addAll(headers);
    response = await request.send();
    Tools.logToConsole('response');
    Tools.logToConsole(response);
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
}

import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../models/barcode_model.dart';

abstract class BarcodeRemoteDataSource {
  Future<String> setBarcodeToProduct({int barcode, int productId});

  Future<Unit> deleteBarcode({String barcodeId});
}

class BarcodeRemoteDataSourceImplement implements BarcodeRemoteDataSource {
  @override
  Future<String> setBarcodeToProduct({int barcode, int productId}) async {
    var requestBody = {'product_id': productId, 'barcode': barcode};
    Response response =
        await ApiProvider.sendRequest(url: productBarcodeApi, method: HttpMethods.post, body: jsonEncode(requestBody));
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return createBarcodeResponseModelFromJson(jsonEncode(response.data)).data.barcode;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> deleteBarcode({String barcodeId}) async {
    Response response = await ApiProvider.sendRequest(url: productBarcodeApi + barcodeId, method: HttpMethods.delete);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

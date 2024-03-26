import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core_importer.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<Unit> updateOrderProduct({int orderId, String updateKey, String updateValue, int productId});

  Future<Unit> addImageToOrder({int orderId, File image});

  Future<Unit> deleteImageFromOrder({int imageId});
  Future<Unit> authCodeOrder({ int orderId, String code , int subWareHouseId});
}

class OrderDetailsRemoteDataSourceImplement implements OrderDetailsRemoteDataSource {
  @override
  Future<Unit> addImageToOrder({int orderId, File image}) async {
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + '/api/' + orderImageApi));
    request.fields.addAll({'order_id': orderId.toString()});
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    try {
      if (response != null) {
        if (response.statusCode == successCode) return Future.value(unit);
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> deleteImageFromOrder({int imageId}) async {
    var response = await ApiProvider.sendRequest(url: orderImageApi + imageId.toString(), method: HttpMethods.delete);

    try {
      if (response != null) {
        if (response.statusCode == successCode) return Future.value(unit);
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> updateOrderProduct({int orderId, String updateKey, String updateValue, int productId}) async {
    Map updateOrderBody = {updateKey: updateValue, 'product_id': productId};
    var response = await ApiProvider.sendRequest(
        url: updateOrderProductsApi + orderId.toString(), method: HttpMethods.put, body: jsonEncode(updateOrderBody));

    try {
      if (response != null) {
        if (response.statusCode == successCode) return Future.value(unit);
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> authCodeOrder({int orderId, String code, int subWareHouseId}) async {
    Response response = await ApiProvider.sendRequest(
        url: orderApi+ orderId.toString()+ authCodeOrderApi + subWareHouseId.toString() ,
        method: HttpMethods.post,
        body: {'code': code});
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

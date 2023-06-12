import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<Unit> deleteProduct({int productId});
  Future<Unit> deleteImage({int imageId});
}

class ProductDetailsRemoteDataSourceImplement implements ProductDetailsRemoteDataSource {
  @override
  Future<Unit> deleteProduct({int productId}) async {
    Response response =
        await ApiProvider.sendRequest(url: productApi + productId.toString(), method: HttpMethods.delete);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> deleteImage({int imageId}) async {
    Response response =
        await ApiProvider.sendRequest(url: productImageApi + imageId.toString(), method: HttpMethods.delete);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

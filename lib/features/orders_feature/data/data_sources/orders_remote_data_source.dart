import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class OrdersRemoteDataSource {
  Future<Unit> reAssignOrder({int orderId});
}

class OrdersRemoteDataSourceImplement implements OrdersRemoteDataSource {
  @override
  Future<Unit> reAssignOrder({int orderId}) async {
    Response response =
        await ApiProvider.sendRequest(url: reAssignOrderToShopper + orderId.toString(), method: HttpMethods.put);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

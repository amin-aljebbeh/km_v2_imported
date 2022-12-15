import 'package:kammun_app/core/core_importer.dart';

import '../../../inventory/model/inventory_model_importer.dart';

abstract class RemoteInventoryDataSource {
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber});
}

class RemoteInventoryDataSourceImplement implements RemoteInventoryDataSource {
  @override
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber}) async {
    Response response = await ApiProvider.sendRequest(
        url: getProductsOfWaitingList, method: HttpMethods.get, queryParameters: {'page': pageNumber});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return filteredProductsModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

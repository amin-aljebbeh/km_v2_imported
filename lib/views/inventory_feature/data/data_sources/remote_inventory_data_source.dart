import 'package:kammun_app/core/core_importer.dart';

import '../../../inventory/model/inventory_model_importer.dart';

abstract class RemoteInventoryDataSource {
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber});
}

class RemoteInventoryDataSourceImplement implements RemoteInventoryDataSource {
  @override
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber}) async {
    try {
      Response response = await ApiProvider.sendRequest(
          url: getProductsOfWaitingList, method: HttpMethods.get, queryParameters: {'page': pageNumber});
      if (response != null) {
        if (response.statusCode == successCode) {
          return filteredProductsModelFromJson(jsonEncode(response.data));
        }
      }
      throw (ServerException());
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
  }
}

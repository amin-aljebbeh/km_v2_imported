import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../../inventory/model/inventory_model_importer.dart';
import '../models/prime_products_response_model.dart';

abstract class RemoteInventoryDataSource {
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber, int subWarehouseId, int isActive});
  Future<FilteredProductsModel> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive});
  Future<List<ProductData>> getUnderCheckAvailability({int subWarehouseId});
  Future<Unit> targetInventory();
}

class RemoteInventoryDataSourceImplement implements RemoteInventoryDataSource {
  @override
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber, int subWarehouseId, int isActive}) async {
    Response response = await ApiProvider.sendRequest(
        url: getProductsOfWaitingListApi,
        method: HttpMethods.get,
        queryParameters: {'page': pageNumber, 'sub_warehouse_id': subWarehouseId, 'is_active': isActive});
    try {
      if (response != null) {
        if (response.statusCode == successCode) return filteredProductsModelFromJson(jsonEncode(response.data));
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<FilteredProductsModel> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive}) async {
    Response response = await ApiProvider.sendRequest(
        url: primeProductsListApi,
        method: HttpMethods.get,
        queryParameters: {'page': pageNumber, 'sub_warehouse_id': subWarehouseId, 'is_active': isActive});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          return FilteredProductsModel(
              data: primeProductsResponseModelFromJson(jsonEncode(response.data)).data.primeProducts);
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ProductData>> getUnderCheckAvailability({int subWarehouseId}) async {
    Response response = await ApiProvider.sendRequest(
        url: underCheckAvailabilityApi, method: HttpMethods.get, queryParameters: {'sub_warehouse_id': subWarehouseId});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          ProductsToReview productsToReview = productsToReviewFromJson(jsonEncode(response.data));
          List<ProductData> products = [];
          products.addAll(productsToReview.productsToActivate);
          products.addAll(productsToReview.productsToDeactivate);
          return products;
        }
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> targetInventory() async {
    Response response = await ApiProvider.sendRequest(url: targetSubWarehouse + '62', method: HttpMethods.post);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

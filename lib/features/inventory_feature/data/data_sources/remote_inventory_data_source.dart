import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../../../cart/data/models/get_cart_model.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import '../../../products/data/models/product_model.dart';
import '../models/prime_products_response_model.dart';

abstract class RemoteInventoryDataSource {
  Future<FilteredProductsModel> getNotificationProducts({int pageNumber, int subWarehouseId, int isActive});

  Future<FilteredProductsModel> getPrimeProducts({int pageNumber, int subWarehouseId, int isActive});

  Future<List<ProductModel>> getUnderCheckAvailability({int subWarehouseId});

  Future<List<ProductModel>> getAllProducts();

  Future<List<ProductModel>> getNotAddedProducts();

  Future<List<ProductModel>> getAddedProducts();

  Future<Unit> targetInventory();

  Future<Unit> keepingAnInventoriesRecord();
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
  Future<List<ProductModel>> getUnderCheckAvailability({int subWarehouseId}) async {
    Response response = await ApiProvider.sendRequest(
        url: underCheckAvailabilityApi, method: HttpMethods.get, queryParameters: {'sub_warehouse_id': subWarehouseId});
    try {
      if (response != null) {
        if (response.statusCode == successCode) {
          ProductsToReview productsToReview = productsToReviewFromJson(jsonEncode(response.data));
          List<ProductModel> products = [];
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
    Response response = await ApiProvider.sendRequest(url: targetSubWarehouseApi + '62', method: HttpMethods.post);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<Unit> keepingAnInventoriesRecord() async {
    Response response = await ApiProvider.sendRequest(url: keepingAnInventoriesRecordApi, method: HttpMethods.post);
    try {
      if (response != null) if (response.statusCode == successCode) return Future.value(unit);
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    Response response = await ApiProvider.sendRequest(url: productApi, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getProductsFromJson(jsonEncode(response.data)).products;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ProductModel>> getNotAddedProducts() async {
    Response response = await ApiProvider.sendRequest(url: getNotAddedProductsToWarehouseApi, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getProductsFromJson(jsonEncode(response.data)).products;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }

  @override
  Future<List<ProductModel>> getAddedProducts() async {
    Response response = await ApiProvider.sendRequest(url: getAddedProductsToWarehouseApi, method: HttpMethods.get);
    try {
      if (response != null) {
        if (response.statusCode == successCode) return getProductsFromJson(jsonEncode(response.data)).products;
      }
    } catch (e) {
      throw (InternalException(message: e.toString()));
    }
    throw (ServerException());
  }
}

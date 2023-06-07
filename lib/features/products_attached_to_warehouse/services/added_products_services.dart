import 'package:kammun_app/core/core_importer.dart';

import '../../products/data/models/product_model.dart';
import '../../products/domain/entities/product_entity.dart';

class AddedProductsServices {
  static Future<List<ProductModel>> getAddedProductsToWarehouseService() async {
    try {
      var response = await ApiProvider.sendRequest(url: getAddedProductsToWarehouse, method: HttpMethods.get);
      if (response.statusCode == successCode && response.data['success']) {
        return syncCartFromJson(jsonEncode(response.data['data']));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductModel>> getNotAddedProductsToWarehouseService() async {
    var response = await ApiProvider.sendRequest(url: getNotAddedProductsToWarehouse, method: HttpMethods.get);
    if (response.statusCode == successCode && response.data['success']) {
      return syncCartFromJson(jsonEncode(response.data['data']));
    }
    return null;
  }

  static Future<bool> unAttachProductsToSubWarehouseService({String productsId, String subWarehouse}) async {
    try {
      Map<String, int> body = {'sub_warehouse_id': int.parse(subWarehouse)};
      var response = await ApiProvider.sendRequest(
          queryParameters: body,
          responseType: ResponseType.json,
          url: unAttachProductsToSubWarehouse + productsId,
          method: HttpMethods.delete);

      return response.statusCode == successCode && response.data['success'];
    } catch (e) {
      return false;
    }
  }

  static Future<bool> attachProductsToSubWarehouseService({dynamic fullRequestBody}) async {
    try {
      var response = await ApiProvider.sendRequest(
          url: attachProductsToSubWarehouse, method: HttpMethods.post, body: jsonEncode(fullRequestBody));

      return response.statusCode == successCode && response.data['success'];
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductModel>> getAllProducts() async {
    var response = await ApiProvider.sendRequest(url: product, method: HttpMethods.get);
    if (response.statusCode == successCode && response.data['success']) {
      return syncCartFromJson(jsonEncode(response.data['data']));
    }
    return null;
  }

  static Future<bool> changeProductSubWarehouse(
      ProductEntity product, String productSubWarehouseId, bool remove) async {
    var subWarehouseBody = {
      'product_id': product.id,
      'sub_warehouse_id': productSubWarehouseId,
      'price': product.price,
      'is_featured': product.isFeatured,
      'is_active': product.isActive,
      'priority': product.priority,
      'supplier_code': product.supplierCode,
      'min_threshold': product.minThreshold,
      'increase_percentage': product.increasePercentage,
      'price_factor': product.priceFactor,
      'automatic_activation': product.automaticActivation,
    };
    try {
      bool removed;
      if (remove) {
        removed = await AddedProductsServices.unAttachProductsToSubWarehouseService(
            productsId: product.id.toString(), subWarehouse: product.subWarehouseId.toString());
      } else {
        removed = true;
      }
      bool add = false;
      if (removed) {
        add = await AddedProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
      }
      if (!add && removed) {
        var subWarehouseBody = {
          'product_id': product.id,
          'sub_warehouse_id': product.subWarehouseId,
          'price': product.price,
          'is_featured': product.isFeatured,
          'is_active': product.isActive,
          'priority': product.priority,
          'supplier_code': product.supplierCode,
          'min_threshold': product.minThreshold,
          'increase_percentage': product.increasePercentage,
          'price_factor': product.priceFactor,
          'automatic_activation': product.automaticActivation,
        };
        await AddedProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
      }
      return removed && add;
    } catch (e) {
      return false;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class AddedProductsServices {
  static Future<List<ProductData>> getAddedProductsToWarehouseService() async {
    try {
      var response = await ApiProvider.sendRequest(
        url: getAddedProductsToWarehouse,
        method: HttpMethods.get,
      );
      if (response.statusCode == successCode && response.data["success"]) {
        return syncCartFromJson(jsonEncode(response.data["data"]));
      } else {
        Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<ProductData>> getNotAddedProductsToWarehouseService() async {
    var response = await ApiProvider.sendRequest(
      url: getNotAddedProductsToWarehouse,
      method: HttpMethods.get,
    );
    if (response.statusCode == successCode && response.data["success"]) {
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> unAttachProductsToSubWarehouseService({
    String productsId,
    String subWarehouse,
  }) async {
    try {
      Map<String, int> body = {'sub_warehouse_id': int.parse(subWarehouse)};
      var response = await ApiProvider.sendRequest(
        queryParameters: body,
        responseType: ResponseType.json,
        url: unAttachProductsToSubWarehouse + productsId,
        method: HttpMethods.delete,
      );

      if (response.statusCode == successCode && response.data["success"]) {
        return true;
      } else {
        Tools.logToConsole("------------ ERROR remove product --------------");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> attachProductsToSubWarehouseService({
    dynamic fullRequestBody,
  }) async {
    try {
      Tools.logToConsole(fullRequestBody);
      var response = await ApiProvider.sendRequest(
          url: attachProductsToSubWarehouse, method: HttpMethods.post, body: jsonEncode(fullRequestBody));

      if (response.statusCode == successCode && response.data["success"]) {
        return true;
      } else {
        Tools.logToConsole(response.data['reason']);
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return null;
    }
  }

  static Future<List<ProductData>> getAllProducts() async {
    var response = await ApiProvider.sendRequest(
      url: getProduct,
      method: HttpMethods.get,
    );
    if (response.statusCode == successCode && response.data["success"]) {
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> changeProductSubWarehouse(
      ProductData product, String productSubWarehouseId, bool remove) async {
    var subWarehouseBody = {
      "product_id": product.id.toString(),
      "sub_warehouse_id": productSubWarehouseId,
      "price": product.price,
      "is_featured": product.isFeatured,
      "is_active": product.isActive,
      "priority": product.priority.toString(),
      "supplier_code": product.supplierCode,
      "min_threshold": product.minThreshold.toString(),
      "increase_percentage": product.increasePercentage,
      "price_factor": product.priceFactor,
      "automatic_activation": product.automaticActivation,
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
          "product_id": product.id.toString(),
          "sub_warehouse_id": product.subWarehouseId.toString(),
          "price": product.price,
          "is_featured": product.isFeatured,
          "is_active": product.isActive,
          "priority": product.priority.toString(),
          "supplier_code": product.supplierCode,
          "min_threshold": product.minThreshold.toString(),
          "increase_percentage": product.increasePercentage,
          "price_factor": product.priceFactor,
          "automatic_activation": product.automaticActivation.toString(),
        };
        await AddedProductsServices.attachProductsToSubWarehouseService(fullRequestBody: subWarehouseBody);
      }
      return removed && add;
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

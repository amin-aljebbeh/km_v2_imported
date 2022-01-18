import 'dart:convert';
import 'package:kammun_app/core/api/api_importer.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class AddedProductsServices {
  static Future<List<ProductData>> getAddedProductsToWarehouse() async {
    var response = await ApiProvider.sendRequest(
      url: GET_ADDED_PRODUCTS_TO_WAREHOUSE,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<List<ProductData>> getNotAddedProductsToWarehouse() async {
    var response = await ApiProvider.sendRequest(
      url: GET_NOT_ADDED_PRODUCTS_TO_WAREHOUSE,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> unAttachProductsToSubWarehouse({
    String productsId,
    String subWarehouse,
  }) async {
    var response = await ApiProvider.sendRequest(
        url: UN_ATTACH_PRODUCTS_TO_SUB_WAREHOUSE + productsId,
        method: httpMethods.delete,
        body: jsonEncode({"sub_warehouse_id": int.parse(subWarehouse)}));

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      Tools.logToConsole(response.data);

      return false;
    }
  }

  static Future<bool> attachProductsToSubWarehouse({
    dynamic fullRequestBody,
  }) async {
    Tools.logToConsole('print link');
    var response = await ApiProvider.sendRequest(
        url: ATTACH_PRODUCTS_TO_SUB_WAREHOUSE, method: httpMethods.post, body: jsonEncode(fullRequestBody));

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      Tools.logToConsole("Product Attached to products successfully");
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      Tools.logToConsole(response.data);

      return false;
    }
  }

  static Future<List<ProductData>> getAllProducts() async {
    var response = await ApiProvider.sendRequest(
      url: GET_PRODUCT,
      method: httpMethods.get,
    );
    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      Tools.logToConsole('message');
      Tools.logToConsole(
          syncCartFromJson(jsonEncode(response.data["data"]))[0].warehouses[0].pivot.subWarehouseId);
      return syncCartFromJson(jsonEncode(response.data["data"]));
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      return null;
    }
  }

  static Future<bool> changeProductSubWarehouse(ProductData product, String productSubWarehouseId) async {
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
      bool remove = await AddedProductsServices.unAttachProductsToSubWarehouse(
          productsId: product.id.toString(), subWarehouse: product.subWarehouseId.toString());
      bool add = false;
      if (remove)
        add = await AddedProductsServices.attachProductsToSubWarehouse(fullRequestBody: subWarehouseBody);
      if (!add && remove) {
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
        await AddedProductsServices.attachProductsToSubWarehouse(fullRequestBody: subWarehouseBody);
      }
      return remove && add;
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

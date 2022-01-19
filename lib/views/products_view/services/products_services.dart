import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/api_importer.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:http/http.dart' as http;
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';

class ProductsServices {
  static Future<bool> updateProductsDetails({
    String bodyKey,
    String value,
    @required String productId,
    bool isForSubWarehouse = true,
    String subWarehouseId,
  }) async {
    try {
      var body;

      body = {bodyKey: value};

      var response;
      if (bodyKey == "category_id") {
        response = await ApiProvider.sendRequest(
            url: ADD_PRODUCTS_TO_CATEGORY + productId, method: httpMethods.post, body: jsonEncode(body));
      } else if (!isForSubWarehouse) {
        response = await ApiProvider.sendRequest(
            url: GET_PRODUCT + productId, method: httpMethods.put, body: jsonEncode(body));
      } else {
        response = await ApiProvider.sendRequest(
            url: UPDATE_SUB_WAREHOUSE_PRODUCTS + productId,
            method: httpMethods.put,
            body: jsonEncode({"sub_warehouse_id": subWarehouseId, bodyKey: value}));
      }
      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Error While Adding the Product $e");
      return false;
    }
  }

  static Future<bool> removeProductFromCategory({@required String productId, @required String categoryId}) async {
    try {
      var response = await ApiProvider.sendRequest(
        queryParameters: {'category_id': categoryId},
        url: REMOVE_PRODUCT_FROM_CATEGORY + productId,
        method: httpMethods.delete,
      );
      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else
        return false;
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }

  static Future<int> addNewProducts(
      {String name,
      String quantity,
      String unit,
      String description,
      String categoryId,
      String price,
      String isActive,
      String supplierCode,
      String minThreshold,
      String priceFactor,
      bool autoActivation,
      @required String subWarehouseId}) async {
    var productBody = {
      "name": name,
      "unit": unit,
      "is_in_facebook": 0,
      "description": description,
      "category_ids": categoryId,
      "quantity": quantity,
    };

    try {
      var response =
          await ApiProvider.sendRequest(url: GET_PRODUCT, method: httpMethods.post, body: jsonEncode(productBody));

      if (response.statusCode == SUCCESS_CODE && response.data["success"] == true) {
        var subWarehouseBody = {
          "product_id": response.data["data"]["id"].toString(),
          "sub_warehouse_id": subWarehouseId,
          "price": price,
          "is_featured": 0,
          "is_active": isActive,
          "priority": 20,
          "supplier_code": supplierCode,
          "min_threshold": 0,
          "increase_percentage": 0,
          "price_factor": priceFactor,
          "automatic_activation": autoActivation,
        };
        bool result = await AddedProductsServices.attachProductsToSubWarehouse(fullRequestBody: subWarehouseBody);
        if (result) {
          return int.parse(response.data["data"]["id"].toString());
        } else {
          return null;
        }
      } else {
        return 0;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return 0;
    }
  }

  static Future<bool> setImageToProducts({File image, int productId}) async {
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(BASE_URL + ADD_IMAGE_TO_PRODUCTS));
    request.fields.addAll({'product_id': '$productId'});
    request.files.add(await http.MultipartFile.fromPath('image', '${image.path}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<bool> deleteProduct(String productId) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: DELETE_PRODUCT + productId,
        method: httpMethods.delete,
      );
      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else
        return false;
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

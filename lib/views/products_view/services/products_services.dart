import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:http/http.dart' as http;
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
      Tools.logToConsole("is for subwarehouse $isForSubWarehouse");
      var body;

      body = {bodyKey: value};

      Tools.logToConsole("THE BODY FROM ATTCCH PRODUCT $body");

      var response;
      if (bodyKey == "category_id") {
        response = await ApiProvider.sendRequest(
            url: ADD_PRODUCTS_TO_CATEGORY + productId,
            method: httpMethods.post,
            body: jsonEncode(body));
      } else if (!isForSubWarehouse) {
        Tools.logToConsole("Updating Products information $body");
        response = await ApiProvider.sendRequest(
            url: GET_PRODUCT + productId,
            method: httpMethods.put,
            body: jsonEncode(body));
      } else {
        Tools.logToConsole("Updating warehouse information $body");
        response = await ApiProvider.sendRequest(
            url: UPDATE_SUB_WAREHOUSE_PRODUCTS + productId,
            method: httpMethods.put,
            body: jsonEncode(
                {"sub_warehouse_id": subWarehouseId, bodyKey: value}));
      }
      if (response.statusCode == SUCCESS_CODE &&
          response.shopper["success"] == true) {
        Tools.logToConsole(response.shopper);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Error While Adding the Product $e");
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
      var response = await ApiProvider.sendRequest(
          url: GET_PRODUCT,
          method: httpMethods.post,
          body: jsonEncode(productBody));

      if (response.statusCode == SUCCESS_CODE &&
          response.data["success"] == true) {
        Tools.logToConsole(
            "THE Product Id from Add PRoduct is : ${response.data["data"]["id"]}");
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
        bool result = await AddedProductsServices.attcahProductsToSubWarehouse(
            fullRequestBody: subWarehouseBody);
        if (result) {
          Tools.logToConsole("Product Added");
          Tools.logToConsole(response.data);
          Tools.logToConsole(response.data["data"]["id"].toString());

          return int.parse(response.data["data"]["id"].toString());
        } else {
          Tools.logToConsole(result);
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
    var headers = {
      'Authorization':
          LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(BaseUrl + ADD_IMAGE_TO_PRODUCTS));
    request.fields.addAll({'product_id': '$productId'});
    request.files
        .add(await http.MultipartFile.fromPath('image', '${image.path}'));
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
}

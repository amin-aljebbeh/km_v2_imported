import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';

class ProductsServices {
  static Future<bool> updateProductsDetails(
      {String bodyKey, String value, String productId}) async {
    var body = {bodyKey: value};

    var response = await ApiProvider.sendRequest(
        url: GET_PRODUCT + productId,
        method: httpMethods.put,
        body: jsonEncode(body));

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole(response.data);
      return true;
    } else {
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
      String priceFactor}) async {
    var body = {
      "name": name,
      "unit": unit,
      "is_in_facebook": 0,
      "description": description,
      "category_id": categoryId,
      "price": price,
      "quantity": quantity,
      "is_featured": 0,
      "is_active": isActive,
      "priority": 20,
      "supplier_code": supplierCode,
      "min_threshold": minThreshold,
      "increase_percentage": 0,
      "price_factor": priceFactor,
    };

    var response = await ApiProvider.sendRequest(
        url: GET_PRODUCT, method: httpMethods.post, body: jsonEncode(body));

    if (response.statusCode == SUCCESS_CODE &&
        response.data["success"] == true) {
      Tools.logToConsole("Product Added");
      Tools.logToConsole(response.data);
      return int.parse(response.data["data"]["id"].toString());
    } else {
      return 0;
    }
  }

  static Future<bool> setImageToProducts({File image, int productId}) async {
    // var body = {
    //   "product_id": productId,
    //   "image": image,
    // };
    try {
      // FormData formData = FormData.fromMap({
      //   "product_id": productId,
      //   "image": await MultipartFile.fromFile("${image.path.toString()}",
      //       filename: "upload.jpg")
      // });
      // var response = await ApiProvider.sendRequest(
      //     url: ADD_IMAGE_TO_PRODUCTS,
      //     method: httpMethods.post,
      //     body: jsonEncode(jsonEncode(formData)));

      bool result = await _upload(image, productId);

      if (result) {
        Tools.logToConsole("Image Uploaded");
        // Tools.logToConsole(response.data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Tools.logToConsole("Catched Error");

      Tools.logToConsole(e.toString());
      return false;
    }
  }

  // static Future<bool> _upload(File file, int productId) async {
  //   String fileName = file.path.split('/').last;

  //   FormData data = FormData.fromMap({
  //     "file": await MultipartFile.fromFile(
  //       file.path,
  //       filename: fileName,
  //     ),
  //     "product_id": productId,
  //   });

  //   Tools.logToConsole(BaseUrl + ADD_IMAGE_TO_PRODUCTS);

  //   Dio dio = new Dio();

  //   dio
  //       .post(BaseUrl + ADD_IMAGE_TO_PRODUCTS,
  //           data: data,
  //           options: Options(
  //               followRedirects: false, contentType: "multipart/form-data"))
  //       .then((response) {
  //     print(response);
  //     return true;
  //   }).catchError((error) {
  //     print(error);
  //     return false;
  //   });
  //   return false;
  // }

  static Future<bool> _upload(File file, int productId) async {
    String fileName = file.path.split('/').last;

    Tools.logToConsole(BaseUrl + ADD_IMAGE_TO_PRODUCTS);

    Dio dio = new Dio();

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromFileSync(file.path, filename: fileName),
      "product_id": productId,
    });

    var response =
        await dio.post(BaseUrl + ADD_IMAGE_TO_PRODUCTS, data: formData);

    print(response.data);
  }
}

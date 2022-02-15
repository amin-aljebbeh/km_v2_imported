import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:http/http.dart' as http;
import 'package:kammun_app/utils/utils_importer.dart';

class OrderDetailsServices {
  static Future<bool> updateOrder(
      {String orderId,
      String updateKey,
      String updateValue,
      String productId,
      @required BuildContext context}) async {
    Map updateOrderBody = {updateKey: updateValue, "product_id": productId};
    var response = await ApiProvider.sendRequest(
      url: UPDATE_ORDER_PRODUCTS + orderId,
      method: httpMethods.put,
      body: jsonEncode(updateOrderBody),
    );
    Services.resultFlushBar(context: context, result: response.statusCode == SUCCESS_CODE);
    if (response.statusCode == SUCCESS_CODE) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addImageToOrder({String orderId, File image}) async {
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(BASE_URL + ADD_IMAGE_TO_ORDER));
    request.fields.addAll({'order_id': '$orderId'});
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

  static Future<bool> deleteImageFromOrder({String imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: DELETE_IMAGE_FROM_ORDER + "/$imageId",
        method: httpMethods.delete,
      );

      if (response.statusCode == SUCCESS_CODE) {
        return true;
      } else {
        Tools.logToConsole("------------ ERROR REMOVE ADDRESS --------------");
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

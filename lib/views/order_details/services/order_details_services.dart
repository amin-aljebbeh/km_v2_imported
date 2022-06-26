import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/service.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/loading.dart';

class OrderDetailsServices {
  static Future<bool> updateOrder(
      {String orderId,
      String updateKey,
      String updateValue,
      String productId,
      @required BuildContext context}) async {
    Map updateOrderBody = {updateKey: updateValue, 'product_id': productId};
    var response = await ApiProvider.sendRequest(
      url: updateOrderProducts + orderId,
      method: HttpMethods.put,
      body: jsonEncode(updateOrderBody),
    );
    Tools.logToConsole(response.data.toString());
    Services.resultFlushBar(context: context, result: response.statusCode == successCode);
    if (response.statusCode == successCode) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addImageToOrderService({String orderId, File image}) async {
    var headers = {'Authorization': LoadingScreen.userToken.length > 10 ? LoadingScreen.userToken : ""};
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + addImageToOrder));
    request.fields.addAll({'order_id': orderId});
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteImageFromOrderService({String imageId}) async {
    try {
      var response = await ApiProvider.sendRequest(
        url: deleteImageFromOrder + '/$imageId',
        method: HttpMethods.delete,
      );

      if (response.statusCode == successCode) {
        return true;
      } else {
        Tools.logToConsole('------------ ERROR REMOVE ADDRESS --------------');
        return false;
      }
    } catch (e) {
      Tools.logToConsole(e.toString());
      return false;
    }
  }
}

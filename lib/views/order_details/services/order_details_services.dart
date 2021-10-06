import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/admin_URLs.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/utils/tools.dart';
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
    if (response.statusCode == SUCCESS_CODE) {
      Flushbar(
        backgroundColor: Colors.green,
        // titleText: Text("تمت الإضافة بنجاح"),
        messageText: Text(
          "تم التعديل بنجاح",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk),
        ),

        boxShadows: [
          BoxShadow(
            color: UtilsImporter().colorUtils.primarycolor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.assignment_turned_in,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      return true;
    } else {
      Tools.logToConsole("------------ ERROR CANCEL ORDER --------------");
      Flushbar(
        backgroundColor: Colors.red[900],
        messageText: Text(
          "فشل في العملية يرجى المحاولة من جديد",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk),
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.red,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.close,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      return false;
    }
  }
}

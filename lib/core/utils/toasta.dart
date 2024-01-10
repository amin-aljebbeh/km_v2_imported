
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {

  static showToast(
      {ToastGravity gravity = ToastGravity.BOTTOM,
      Color textColor,
       String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength:Toast.LENGTH_LONG,
        gravity: gravity,
        timeInSecForIosWeb: 3,
        backgroundColor : Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }

}

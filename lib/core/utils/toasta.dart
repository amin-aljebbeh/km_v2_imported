import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Utility {
  static showToast({Color textColor, String message}) {
    Toast.show(
      message,
      gravity: Toast.bottom,
      duration: Toast.lengthLong,
      textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }
}

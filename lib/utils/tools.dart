import 'package:flutter/foundation.dart';

class Tools {
  static void logToConsole(Object message) {
    if (kDebugMode) print(message);
  }
}

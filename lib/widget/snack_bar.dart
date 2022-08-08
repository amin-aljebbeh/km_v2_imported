import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

flushbar({String message, Color color, IconData icon, int duration = 1}) {
  // ScaffoldMessenger.of(navigatorKey.currentContext)
  //   ..removeCurrentSnackBar()
  //   ..showSnackBar(SnackBar(
  //     content: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [Icon(icon, color: Colors.white), Expanded(child: Text(message, style: flushBarStyle))]),
  //     backgroundColor: color,
  //     shape: const StadiumBorder(),
  //     elevation: 0,
  //     behavior: SnackBarBehavior.floating,
  //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //     duration: Duration(seconds: duration),
  //   ));
}

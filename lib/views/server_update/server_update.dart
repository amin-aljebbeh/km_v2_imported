import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';

class ServerUpdate extends StatelessWidget {
  static final String routeName = "/server-update";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/system_update.gif",
                ),
                Text(
                  "تحديثات ضمن النظام",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10, left: 30, right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${LoadingScreenServices.systemMaintenanceMessages}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0), child: _showRestartButton(context)),
              ],
            ),
          ),
          color: Colors.white,
          // color: Color.fromARGB(255, 40, 51, 140),
        ),
      ),
    );
  }
}

Widget _showRestartButton(context) {
  final GestureDetector loginButtonWithGesture = new GestureDetector(
    onTap: () => KammunRestart.restartApp(context),
    child: new Container(
      height: 50.0,
      decoration: new BoxDecoration(
          color: ColorUtils.primaryColor, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
      child: new Center(
        child: new Text(
          "المحاولة من جديد",
          style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              fontFamily: StringUtils.fontFamilyHKGrotesk),
        ),
      ),
    ),
  );

  return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
}

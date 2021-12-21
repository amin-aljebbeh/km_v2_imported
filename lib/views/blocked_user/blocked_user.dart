import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';

class BlockedUser extends StatelessWidget {
  static final String routeName = "/blocked-user";

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
                  "assets/blocked_user.png",
                  width: 100,
                  height: 150,
                ),
                Text(
                  "تم منعك من الوصول",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, left: 30, right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "يبدو أن هناك مشكلة على حسابكم ضمن تطبيق كمّون للمزيد من المعلومات بإمكانكم التواصل مع خدمة العملاء على أحد منصات التواصل",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: KammunButton(
                    text: UtilsImporter().stringUtils.tryAgain,
                    height: 50,
                    color: UtilsImporter().colorUtils.primaryColor,
                    onTap: () => KammunRestart.restartApp(context),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}

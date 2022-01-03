import 'package:flutter/material.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:kammun_app/utils/utils_importer.dart';

class UpdateScreen extends StatelessWidget {
  static final String routeName = "/update";

  _iosUpdateLink() async {
    String url = LoadingScreen.updateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _androidUpdateLink() async {
    String url = LoadingScreen.updateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                  "assets/update.png",
                  width: 100,
                  height: 150,
                ),
                Text(
                  "تحديث مطلوب",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, left: 30, right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      " لديك نسخة قديمة من التطبيق يرجى التحديث حتى تتمكن من الإستفادة من خدمات كمّون ",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: KammunButton(
                    text: " التحديث الآن ",
                    height: 50,
                    color: ColorUtils.primaryColor,
                    onTap: Platform.isAndroid
                        ? () => _androidUpdateLink()
                        : () => _iosUpdateLink(),
                  ),
                ),
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

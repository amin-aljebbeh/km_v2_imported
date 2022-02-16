import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Services.dart';
import 'widgets_importer.dart';

class KDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Drawer(
            child: Container(
              color: Colors.white,
              child: ListView(
                primary: false,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DrawerHeader(
                        decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: ColorUtils.kmColors)),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: ColorUtils.kmColors,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      child: Image.asset(
                        "assets/kmlogoo.png",
                        width: 250,
                        height: 200,
                      ),
                      color: Colors.white),
                  Divider(
                    color: ColorUtils.kmColors,
                  ),
                  SideBarRow(
                    onTap: () {
                      Services.openUrl("number");
                    },
                    text: 'الإتصال بكمون',
                    icon: Icons.phone,
                  ),
                  SideBarRow(
                    onTap: () {
                      _shareApp();
                    },
                    text: 'إرسال التطبيق للأصدقاء',
                    icon: Icons.share,
                  ),
                  SideBarRow(
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    text: StringUtils.profile,
                    icon: Icons.person,
                  ),
                  SideBarRow(
                    onTap: () {
                      launch('http://kammun.com/privacy-policy.html', enableJavaScript: false);
                    },
                    text: 'سياسة الإستخدام',
                    icon: Icons.policy,
                  ),
                  SideBarRow(
                    onTap: () async {
                      showMyDialog(
                          title: 'تأكيد تسجيل الخروج',
                          context: context,
                          text: 'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك 🥺',
                          dialogButtons: [
                            DialogButton(
                              text: StringUtils.yes,
                              onTap: () async {
                                await Services.logOut(context);
                              },
                            ),
                            DialogButton(
                              text: StringUtils.no,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]);
                    },
                    text: StringUtils.logout,
                    icon: Icons.logout,
                  ),
                  Divider(
                    color: ColorUtils.kmColors,
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MediaIcon(icon: FontAwesomeIcons.facebookF, url: "facebook"),
                          MediaIcon(icon: FontAwesomeIcons.instagram, url: "instagram"),
                          MediaIcon(icon: FontAwesomeIcons.facebookMessenger, url: "messenger"),
                          MediaIcon(icon: FontAwesomeIcons.whatsapp, url: "whatsapp"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _shareApp() {
    String infoMessage = "تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n";
    String androidGrating = "\n لتحميل التطبيق على الأندوريد \n";

    String androidUrl = androidGrating + LoadingScreenServices.iOSShareUrl;
    String iosGrating = "\n لتحميل التطبيق على الآيفون \n";
    String iPhoneUrl = iosGrating + LoadingScreenServices.androidShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }
}

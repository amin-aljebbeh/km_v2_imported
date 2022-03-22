import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Services.dart';
import 'widgets_importer.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      SideBarRow(
        onTap: () {
          Services.openUrl("number");
        },
        text: 'الإتصال بكمون',
        icon: Icons.phone,
      ),
      SideBarRow(
        onTap: () {
          Services.shareApp();
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
    ];
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DrawerHeader(
                        decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: ColorUtils.kmColors)),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SizedBox(
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
                  Column(
                    children: children,
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
                        children: const <Widget>[
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
}

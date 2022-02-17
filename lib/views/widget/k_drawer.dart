import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class KDrawer extends StatelessWidget {
  final List<Widget> children;

  const KDrawer({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Drawer(
            child: Column(
              children: [
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
                Container(
                  height: 550,
                  child: ListView(
                    primary: false,
                    children: <Widget>[
                      Column(
                        children: children,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

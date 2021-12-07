import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';

class ThankYouView extends StatefulWidget {
  final String orderMessage;

  ThankYouView({this.orderMessage});

  @override
  State<StatefulWidget> createState() {
    return ThankYouViewState();
  }
}

class ThankYouViewState extends State<ThankYouView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<DialogButton> dialogButtons = [
        DialogButton(
          text: "إغلاق",
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ];
      showMyDialog('ملاحظة على الطلب', widget.orderMessage, dialogButtons, null,
          context);
    });

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        KammunRestart.restartApp(context);
        return;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 10),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/like.png', width: 200, height: 200),
                  SizedBox(height: 50),
                  Text(
                    UtilsImporter().stringUtils.thankyou,
                    style: TextStyle(
                        color: UtilsImporter().colorUtils.primarycolor,
                        fontWeight: FontWeight.w700,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontSize: 30),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      UtilsImporter().stringUtils.thankyoudescrip,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: UtilsImporter().colorUtils.primarycolor,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      widget.orderMessage.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: UtilsImporter().colorUtils.kmColors,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  KammunButton(
                    text: UtilsImporter().stringUtils.continueShopping,
                    color: Theme.of(context).primaryColor,
                    height: 50,
                    onTap: _showContinueShoppingBtnTapped,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContinueShoppingBtnTapped() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/orders', (Route<dynamic> route) => false);

    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new HomeView(2)));
  }
}

import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/widget/dialog_button.dart';
import 'package:kammun_app/views/widget/kammun_button.dart';
import 'package:kammun_app/views/widget/my_dialog.dart';

class ThankYouView extends StatefulWidget {
  final String orderMessage;
  const ThankYouView({Key key, this.orderMessage}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ThankYouViewState();
  }
}

class ThankYouViewState extends State<ThankYouView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMyDialog(
        title: 'شكراً',
        context: context,
        text: widget.orderMessage,
        dialogButtons: [
          DialogButton(
            text: StringUtils.close,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
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
          padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 10),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/like.png', width: 200, height: 200),
                  const SizedBox(height: 50),
                  Text(
                    StringUtils.thankyou,
                    style: TextStyle(
                        color: ColorUtils.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      StringUtils.thankYouDescribe,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.primaryColor,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      widget.orderMessage.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.kmColors,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  KammunButton(
                    color: ColorUtils.primaryColor,
                    onTap: _showContinueShoppingBtnTapped,
                    text: StringUtils.continueShopping,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
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
    Navigator.of(context).pushNamedAndRemoveUntil('/orders', (Route<dynamic> route) => false);
  }
}

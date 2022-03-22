import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showDialog(title: 'ملاحظة على الطلب', body: widget.orderMessage));

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  void _showDialog({title, body}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "$title",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "إغلاق",
                style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  _showContinueShoppingButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showContinueShoppingButton() {
    final GestureDetector showContinueShoppingButtonWithGesture = GestureDetector(
      onTap: _showContinueShoppingBtnTapped,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            StringUtils.continueShopping,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: showContinueShoppingButtonWithGesture);
  }

  void _showContinueShoppingBtnTapped() {
    Navigator.of(context).pushNamedAndRemoveUntil('/orders', (Route<dynamic> route) => false);
  }
}

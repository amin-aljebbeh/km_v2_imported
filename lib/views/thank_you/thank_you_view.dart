import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/widget/close_widget.dart';

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
          title: StringUtils.costumerNote,
          text: widget.orderMessage,
          dialogButtons: [const CloseWidget()],
          context: context);
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
                    StringUtils.thankYou,
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
                    text: StringUtils.continueShopping,
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
    Navigator.of(context).pushNamedAndRemoveUntil('/orders', (Route<dynamic> route) => false);

    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new HomeView(2)));
  }
}

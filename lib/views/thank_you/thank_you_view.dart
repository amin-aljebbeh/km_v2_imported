import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';

class ThankYouView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ThankYouViewState();
  }
}

class ThankYouViewState extends State<ThankYouView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final String message = routeArgs['message'];
    return Scaffold(
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
                        child: Text(UtilsImporter().stringUtils.thankyoudescrip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: UtilsImporter().colorUtils.primarycolor,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 16.0,
                            ))),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 30, top: 10, right: 0, bottom: 10),
                        child: Text(message.toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: UtilsImporter().colorUtils.kmColors,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 16.0,
                            ))),
                    SizedBox(height: 40),
                    _showContinueShoppingButton()
                  ]),
            ))));
  }

  Widget _showContinueShoppingButton() {
    final GestureDetector showContinueShoppingButtonWithGesture =
        new GestureDetector(
      onTap: _showContinueShoppingBtnTapped,
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.continue_shopping,
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
        child: showContinueShoppingButtonWithGesture);
  }

  void _showContinueShoppingBtnTapped() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/orders', (Route<dynamic> route) => false);

    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new HomeView(2)));
  }
}

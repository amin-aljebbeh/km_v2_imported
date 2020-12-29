import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _showDialog(title: 'ملاحظة على الطلب', body: widget.orderMessage));

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
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          content: new Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
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
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 16.0,
                              ))),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 30, top: 10, right: 0, bottom: 10),
                          child: Text(widget.orderMessage.toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: UtilsImporter().colorUtils.kmColors,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 16.0,
                              ))),
                      SizedBox(height: 40),
                      _showContinueShoppingButton()
                    ]),
              )))),
    );
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

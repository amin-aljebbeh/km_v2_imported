import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:url_launcher/url_launcher.dart';

class UsagePolicy extends StatefulWidget {
  final Function(bool) onApprove;
  UsagePolicy(this.onApprove);
  @override
  _UsagePolicyState createState() => _UsagePolicyState();
}

class _UsagePolicyState extends State<UsagePolicy> {
  ScrollController _scroll = new ScrollController();

  Widget _approvePolicy() {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        widget.onApprove(true);
      },
      child: new Container(
        height: 60.0,
        decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.approveUsagePolicy.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 20),
        child: showConfirmButtonWithGesture);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          controller: _scroll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    0, screenHeight * 0.02, 0, screenHeight * 0.02),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide()),
                ),
                child: Text('سياسة الإستخدام',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                        color: UtilsImporter().colorUtils.primarycolor,
                        fontSize: 25)), //font color is diffrent
              ),
              // Container(
              //   alignment: Alignment.center,
              //   margin: EdgeInsets.fromLTRB(17, screenHeight * 0.03, 17, 0),
              //   child: Text(
              //     "تحتاج للموافقة على سياسة الإستخدام الخاصة بتطبيق كمّون حتى تتمكن من التسجيل ",
              //     style: TextStyle(
              //         fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              //         fontSize: 18,
              //         color: Colors.black),
              //   ), //font color is diffrent
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "تحتاج للموافقة على ",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launch(
                                'http://kammun.com/privacy-policy.html',
                                enableJavaScript: false),
                          text: " سياسة الإستخدام ",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text:
                              "الخاصة بتطبيق كمّون حتى تتمكن من إستعمال التطبيق",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _approvePolicy(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).pop(),
                          text: "غير موافق",
                          style: TextStyle(
                            color: Colors.red[800],
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

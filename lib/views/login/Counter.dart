import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import 'package:sms_autofill/sms_autofill.dart';

import '../../Services.dart';
import 'login_view.dart';

// ignore: must_be_immutable
class CounterOtp extends StatefulWidget {
  static const routeName = '/otp-counter';

  int counter;
  int counterMinn;
  Function(bool success) onRequestSent;

  CounterOtp(this.counter, this.counterMinn, this.onRequestSent);

  @override
  _CounterOtpState createState() => _CounterOtpState(counter, counterMinn);
}

class _CounterOtpState extends State<CounterOtp> {
  String signature = "{{ app signature }}";
  String finalCode = "";
  String x = "";
  bool loadingScreen = false;
  int alertMessageState = 0;

  int counter2;
  int counterMin;
  _CounterOtpState(this.counter2, this.counterMin);

  Future fetchOtp() async {
    try {
      setState(() {
        loadingScreen = true;
      });

      await SmsAutoFill().listenForCode;

      String signature = await SmsAutoFill().getAppSignature;

      if (signature.toString().length != 11) {
        signature = "";
      }

      bool response = await Services.loginUser(
          phoneNumber: LoginScreen.phoneNumber, signCode: signature, supportedCityId: LoginScreen.supportedCityId);

      if (response) {
        await SmsAutoFill().listenForCode;
        setState(() {
          loadingScreen = false;
          counter2 = 59;
          counterMin = 0;
        });
        widget.onRequestSent(true);
      } else {
        setState(() {
          loadingScreen = false;
        });
        widget.onRequestSent(false);
      }
    } catch (e) {
      setState(() {
        loadingScreen = false;
        widget.onRequestSent(false);
      });
      throw new Exception(e.toString());
    }
  }

  void startTimer() {
    Timer(Duration(seconds: 1), () {
      if (counter2 == 0 && counterMin > 0) {
        if (this.mounted) {
          setState(() {
            counterMin--;
            counter2 = 59;
          });
        }
      } else if (counter2 > 0) if (this.mounted) {
        setState(() {
          counter2--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startTimer();

    return loadingScreen
        ? Column(
            children: <Widget>[
              Center(
                heightFactor: .1,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Loader(),
                ),
              ),
            ],
          )
        : counter2 > 0 || counterMin > 0
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(color: Colors.grey[400]),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "إعادة إرسال رمز التفعيل",
                          style: TextStyle(
                              color: Colors.black, fontSize: 17, fontFamily: StringUtils.fontFamilyHKGrotesk),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    child: Text(
                      "0$counterMin:" + "${counter2 < 10 ? "0" + "$counter2" : "$counter2"}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //child: Text("$_current"),
                  ),
                ),
              )
            : loadingScreen
                ? Column(
                    children: <Widget>[
                      Center(
                        heightFactor: .6,
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: Loader(),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: fetchOtp,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.grey[400]),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        title: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "إعادة إرسال رمز التفعيل",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  );
  }
}

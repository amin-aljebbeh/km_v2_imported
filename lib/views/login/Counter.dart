import 'dart:async';

import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// import 'package:sms_autofill/sms_autofill.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Services.dart';
import 'login_view.dart';
// import 'package:quiver/async.dart';

// import 'Loader.dart';

class CounterOtp extends StatefulWidget {
  static const routeName = '/otp-counter';

  int counterr;
  int counterMinn;

  CounterOtp(this.counterr, this.counterMinn);

  @override
  _CounterOtpState createState() => _CounterOtpState(counterr, counterMinn);
}

class _CounterOtpState extends State<CounterOtp> {
  String signature = "{{ app signature }}";
  String finalCode = "";
  String x = "";
  bool loadingScreen = false;
  // int counter = 59;
  // int counterMin = 4;
  int alertMessageState = 0;

  int counter;
  int counterMin;
  _CounterOtpState(this.counter, this.counterMin);

  Future featchOtp() async {
    try {
      setState(() {
        loadingScreen = true;
      });

      await SmsAutoFill().listenForCode;

      String signature = await SmsAutoFill().getAppSignature;

      if (signature.toString().length != 11) {
        signature = "";
      }
      Tools.logToConsole("Signature: ###################" + signature.toString());

      bool response = await Services.loginUser(
          phoneNumber: LoginScreen.phoneNumber,
          signCode: signature,
          supportedCityId: LoginScreen.supportedCityId);

      if (response) {
        await SmsAutoFill().listenForCode;
        setState(() {
          loadingScreen = false;
          counter = 59;
          counterMin = 0;
        });
      } else {
        setState(() {
          loadingScreen = false;
        });
      }
    } catch (e) {
      setState(() {
        loadingScreen = false;
      });
      Tools.logToConsole(
          "---------------------------------- FEATCH OTP EXCEPTION ----------------------------------");
      throw new Exception(e.toString());
    }
  }

  void startTimer() {
    Timer(Duration(seconds: 1), () {
      if (counter == 0 && counterMin > 0) {
        if (this.mounted) {
          setState(() {
            counterMin--;
            counter = 59;
          });
        }
      } else if (counter > 0) if (this.mounted) {
        setState(() {
          counter--;
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
        : counter > 0 || counterMin > 0
            ? Container(
                //  margin: EdgeInsets.all(10),
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
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    child: Text(
                      "0$counterMin:" +
                          "${counter < 10 ? "0" + "$counter" : "$counter"}",
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
                    onTap: featchOtp,
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
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk),
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

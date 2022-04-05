import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import 'package:sms_autofill/sms_autofill.dart';

import '../../service.dart';
import 'login_view.dart';

// ignore: must_be_immutable
class CounterOtp extends StatefulWidget {
  static const routeName = '/otp-counter';

  int counter;
  int counterMinn;
  Function(bool success) onRequestSent;

  CounterOtp(this.counter, this.counterMinn, this.onRequestSent, {Key key}) : super(key: key);

  @override
  _CounterOtpState createState() => _CounterOtpState();
}

class _CounterOtpState extends State<CounterOtp> {
  String signature = "{{ app signature }}";
  String finalCode = "";
  String x = "";
  bool loadingScreen = false;
  int alertMessageState = 0;

  Future fetchOtp() async {
    try {
      setState(() {
        loadingScreen = true;
      });

      SmsAutoFill().listenForCode;

      String signature = await SmsAutoFill().getAppSignature;

      if (signature.toString().length != 11) {
        signature = "";
      }

      bool response = await Services.loginUser(
          phoneNumber: LoginScreen.phoneNumber, signCode: signature, supportedCityId: LoginScreen.supportedCityId);

      if (response) {
        SmsAutoFill().listenForCode;
        setState(() {
          loadingScreen = false;
          widget.counter = 59;
          widget.counterMinn = 0;
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
      throw Exception(e.toString());
    }
  }

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      if (widget.counter == 0 && widget.counterMinn > 0) {
        if (mounted) {
          setState(() {
            widget.counterMinn--;
            widget.counter = 59;
          });
        }
      } else if (widget.counter > 0) {
        if (mounted) {
          setState(() {
            widget.counter--;
          });
        }
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
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: const Loader(),
                ),
              ),
            ],
          )
        : widget.counter > 0 || widget.counterMinn > 0
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(color: Colors.grey[400]),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  trailing: Text(
                    "0${widget.counterMinn}:"
                    "${widget.counter < 10 ? "0" "${widget.counter}" : "${widget.counter}"}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : loadingScreen
                ? Column(
                    children: <Widget>[
                      Center(
                        heightFactor: .6,
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: const Loader(),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: fetchOtp,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.grey[400]),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                    ),
                  );
  }
}

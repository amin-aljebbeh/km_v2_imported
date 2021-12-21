import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Services.dart';
import 'Counter.dart';
import 'Services/login_services.dart';

class OTPVerification extends StatefulWidget {
  static String routeName = "/otp";

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  String signature = "{{ app signature }}";
  bool errorCode = false;
  bool loadingScreen = false;
  String errorMessage = "رمز التفعيل الخاص بك غير صحيح";

  Future checkOtpValidation(String verificationCode) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Tools.logToConsole(
        LoginServices.replaceFarsiNumber(verificationCode.toString()));
    try {
      setState(() {
        loadingScreen = true;
      });
      bool response = await Services.verifyCode(
          LoginServices.replaceFarsiNumber(
              LoginServices.replaceFarsiNumber(verificationCode.toString())));
      Tools.logToConsole(response.toString());
      if (response) {
        await Navigator.of(context).pushNamedAndRemoveUntil(
            '/supportedCity', (Route<dynamic> route) => false);
        // KammunRestart.restartApp(context);
      } else {
        setState(() {
          errorCode = true;
          loadingScreen = false;
          _textController.text = "";
        });
        Tools.logToConsole("Error");
      }
    } catch (e) {
      setState(() {
        loadingScreen = false;
        errorCode = true;
        _textController.text = "";
      });
      Tools.logToConsole(
          "--------------------- Cehck OTP EXCEption ----------------------");
      Tools.logToConsole(e.toString());
    }
  }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    super.dispose();
  }

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScrollController _scroll = new ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          controller: _scroll,
          child: Column(
            children: <Widget>[
              errorCode
                  ? AlertMessages(
                      text: errorMessage,
                      messageType: "internetError",
                      headerText: "حدث خطأ أثناء التفعيل",
                    )
                  : Container(
                      padding: EdgeInsets.zero,
                    ),
              Container(
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Image.asset(
                        "assets/loginLogo.png",
                        height: 100,
                        width: 75,
                      ),
                    ),
                  ),
                  // width: double.infinity,
                  // height: MediaQuery.of(context).size.height,
                  color: Colors.white),
              Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50.0, right: 10, left: 10),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "سوف يتم إرسال رسالة تفعيل إلى الرقم ",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: " ${LoginScreen.phoneNumber} ",
                              style: TextStyle(
                                color: UtilsImporter().colorUtils.primaryColor,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "عبر رسالة (SMS)",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.of(context).pushReplacementNamed(
                                      LoginScreen.routeName,
                                    ),
                              text: " تغيير الرقم ",
                              style: TextStyle(
                                color: UtilsImporter().colorUtils.kmColors,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  color: Colors.white),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 5.0, right: 15, left: 15.0),
                child: PinFieldAutoFill(
                  currentCode: _textController.text,
                  onCodeChanged: (finalCode) {
                    _textController.text = finalCode;

                    finalCode.length == 6 && errorCode != true
                        ? checkOtpValidation(_textController.text)
                        : Tools.logToConsole('');
                  },
                  onCodeSubmitted: (finalCode) =>
                      _textController.text = finalCode,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: loadingScreen
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                        child: Loader(),
                      )
                    : KammunButton(
                        text: "تأكيد الرمز",
                        height: 50,
                        color: UtilsImporter().colorUtils.primaryColor,
                        onTap: () {
                          if (_textController.text.length == 6) {
                            checkOtpValidation(_textController.text);
                          } else {
                            setState(() {
                              errorCode = true;
                            });
                          }
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CounterOtp(59, 0, (success) {
                  if (success) {
                    setState(() {
                      errorCode = false;
                    });
                  } else {
                    errorMessage =
                        "حدث خطأ أثناء محاولة إرسال الرمز من جديد يرجى التحقق من إتصالك بالإانترنت و المحاولة من جديد";
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

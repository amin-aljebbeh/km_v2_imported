import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../../service.dart';
import '../loading/loading_services.dart';
import 'counter.dart';
import 'Services/login_services.dart';
import 'package:countdown_flutter/countdown_flutter.dart';

class OTPVerification extends StatefulWidget {
  static String routeName = "/otp";

  const OTPVerification({Key key}) : super(key: key);

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

    try {
      setState(() {
        loadingScreen = true;
      });
      bool response = await Services.verifyCode(
          LoginServices.replaceFarsiNumber(
              LoginServices.replaceFarsiNumber(verificationCode.toString())));

      if (response) {
        try {
          final u = await VChatController.instance.register(
            dto: VChatRegisterDto(
              name: "Test",

              /// if you pass imagePath to null v chat will use the default user image
              /// see here for msore info
              userImage: null,
              email: '5000000001',
            ),
            context: context,
          );
          Tools.logToConsole("V_chat Start register");
        } on VChatSdkException catch (err) {
          final u = await VChatController.instance
              .login(context: context, email: '5000000001');
          Tools.logToConsole("V_chat start login user already registered");
        }
        await Navigator.of(context).pushNamedAndRemoveUntil(
            '/supportedCity', (Route<dynamic> route) => false);
      } else {
        setState(() {
          errorCode = true;
          loadingScreen = false;
          _textController.text = "";
        });
      }
    } catch (e) {
      setState(() {
        loadingScreen = false;
        errorCode = true;
        _textController.text = "";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _textController = TextEditingController();
  bool tryAgain = false;
  Future fetchOtp() async {
    try {
      setState(() {
        loadingScreen = true;
      });

      SmsAutoFill().listenForCode;

  @override
  Widget build(BuildContext context) {
    ScrollController _scroll = ScrollController();

    Widget _showAddAddressButton() {
      final GestureDetector loginButtonWithGesture = GestureDetector(
        onTap: () {
          if (_textController.text.length == 6) {
            checkOtpValidation(_textController.text);
          } else {
            setState(() {
              errorCode = true;
            });
          }
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              color: ColorUtils.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
          child: Center(
            child: Text(
              "تأكيد الرمز",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: StringUtils.fontFamilyHKGrotesk),
            ),
          ),
        ),
      );

      return loadingScreen
          ? const Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
              child: Loader(),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
              child: loginButtonWithGesture);
    }
      if (signature.toString().length != 11) {
        signature = "";
      }

      bool response = await Services.loginUser(
          phoneNumber: LoginScreen.phoneNumber, signCode: signature, supportedCityId: LoginScreen.supportedCityId);

      if (response) {
        SmsAutoFill().listenForCode;
        setState(() {
          loadingScreen = false;
        });
      } else {
        setState(() {
          loadingScreen = false;
        });
      }
    } catch (e) {
      setState(() {
        loadingScreen = false;
        errorCode = true;
        errorMessage =
            "حدث خطأ أثناء محاولة إرسال الرمز من جديد يرجى التحقق من إتصالك بالإانترنت و المحاولة من جديد";
      });
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scroll = ScrollController();
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
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: " ${LoginScreen.phoneNumber} ",
                              style: TextStyle(
                                color: ColorUtils.primaryColor,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "عبر رسالة (SMS)",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                                color: ColorUtils.kmColors,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
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
              loadingScreen
                  ? const Loader()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: KammunButton(
                            color: ColorUtils.primaryColor,
                            onTap: () {
                              if (_textController.text.length == 6) {
                                checkOtpValidation(_textController.text);
                              } else {
                                setState(() {
                                  errorCode = true;
                                });
                              }
                            },
                            text: "تأكيد الرمز",
                            height: 50,
                          ),
                        ),
                        tryAgain
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: KammunButton(
                                  height: 50,
                                  color: ColorUtils.primaryColor,
                                  onTap: () {
                                    setState(() {
                                      tryAgain = false;
                                    });
                                    fetchOtp();
                                  },
                                  text: 'إعادة إرسال رمز التفعيل',
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(color: ColorUtils.primaryColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15, left: 25, right: 25, top: 15),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Countdown(
                                            onFinish: () {
                                              setState(() {
                                                tryAgain = true;
                                              });
                                            },
                                            builder: (BuildContext ctx, Duration remaining) {
                                              String time = remaining.inSeconds.toString();
                                              String zero = '';
                                              if (remaining.inSeconds < 10) {
                                                zero = '0';
                                              }
                                              return Text(
                                                '00:$zero$time',
                                                textDirection: TextDirection.ltr,
                                                style: paragraphStyle,
                                              );
                                            },
                                            duration: const Duration(seconds: 60),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              fetchOtp();
                                            },
                                            icon: Icon(
                                              Icons.refresh_outlined,
                                              color: ColorUtils.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

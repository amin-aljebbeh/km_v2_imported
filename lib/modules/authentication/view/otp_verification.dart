import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../redux/authentication_action.dart';
import '../service/authentication_service.dart';
import 'login_view.dart';

class OTPVerification extends StatefulWidget {
  static String routeName = '/otp';

  const OTPVerification({Key key}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  ScrollController scroll = ScrollController();
  Future initialVar;
  CountdownController controller = CountdownController();

  Future checkOtpValidation(String verificationCode) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    StoreProvider.of<AppState>(context)
        .dispatch(VerifyCode(verificationCode: AuthenticationServices.replaceFarsiNumber(verificationCode.toString())));
  }

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if (state.authenticationState.isLoggedIn) {
          return const Scaffold(body: LoadingScreen());
        } else {
          return TemporaryLoading(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  reverse: true,
                  controller: scroll,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.zero,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Center(child: Image.asset('assets/loginLogo.png', height: 100, width: 75))),
                        color: Colors.white,
                      ),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 10, left: 10),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'سوف يتم إرسال رسالة تفعيل إلى الرقم ',
                                      style: TextStyle(
                                        color: Colors.grey[900],
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: state.authenticationState.phoneNumber,
                                      style: TextStyle(
                                        color: ColorUtils.primaryColor,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'عبر رسالة (SMS)',
                                      style: TextStyle(
                                        color: Colors.grey[900],
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap =
                                            () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
                                      text: ' تغيير الرقم ',
                                      style: TextStyle(
                                        color: ColorUtils.kmColors,
                                        fontFamily: StringUtils.fontFamily,
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
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 15, left: 15.0),
                        child: PinFieldAutoFill(
                          currentCode: _textController.text,
                          onCodeChanged: (finalCode) {
                            _textController.text = finalCode;
                            if (finalCode.length == 6 && !state.errorState.isError) {
                              checkOtpValidation(_textController.text);
                            }
                          },
                          onCodeSubmitted: (finalCode) => _textController.text = finalCode,
                        ),
                      ),
                      state.loadingState.isLoading
                          ? Container()
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 25, right: 10, left: 10, bottom: 10),
                                  child: KButton(
                                    color: ColorUtils.primaryColor,
                                    onTap: () {
                                      if (_textController.text.length == 6) {
                                        checkOtpValidation(_textController.text);
                                      } else {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(CatchError(errorMessage: 'رمز التفعيل الخاص بك غير صحيح'));
                                      }
                                    },
                                    text: 'تأكيد الرمز',
                                    height: 50,
                                  ),
                                ),
                                state.authenticationState.reSendCode
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: KButton(
                                          height: 50,
                                          color: ColorUtils.primaryColor,
                                          onTap: () {
                                            StoreProvider.of<AppState>(context).dispatch(ReSendCode(reSend: false));
                                            StoreProvider.of<AppState>(context).dispatch(FetchVerificationCode(
                                                phoneNumber: state.authenticationState.phoneNumber));
                                          },
                                          text: 'إعادة إرسال رمز التفعيل',
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            border: Border.all(color: ColorUtils.primaryColor),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 15, left: 25, right: 25, top: 15),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Countdown(
                                                    controller: controller,
                                                    seconds: 60,
                                                    build: (_, double time) => Text(
                                                        (time < 10 ? '0' : '') + time.toString().split('.')[0] + ':00',
                                                        style: paragraphStyle),
                                                    onFinished: () => StoreProvider.of<AppState>(context)
                                                        .dispatch(ReSendCode(reSend: true)),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      controller.restart();
                                                      StoreProvider.of<AppState>(context).dispatch(
                                                          FetchVerificationCode(
                                                              phoneNumber: state.authenticationState.phoneNumber));
                                                    },
                                                    icon: Icon(Icons.refresh, color: ColorUtils.primaryColor),
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
            ),
          );
        }
      },
    );
  }
}

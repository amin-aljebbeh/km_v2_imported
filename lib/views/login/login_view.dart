import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/login/OTPVerification.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Services.dart';
import 'Services/login_services.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  static String phoneNumber = "";
  static String supportedCityId;

  // static String selectedValue;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String currentText = "";
  final myController = TextEditingController();
  final _passwordController = TextEditingController();

  bool errorCode = false;
  bool loadingScreen = false;
  String errorMessage = " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت";

  @override
  void initState() {
    // if (LoadingScreenServices.supportedCitiesListIntro.length == 0) {
    //   Navigator.push(context,
    //       new MaterialPageRoute(builder: (context) => new InternetError()));
    // }

    super.initState();
  }

  Future adminLogin() async {
    setState(() {
      loadingScreen = true;
    });
    if (myController.text.length == 0) {
      setState(() {
        errorCode = true;
        loadingScreen = false;

        errorMessage = "يرجى إدخال اسم المستخدم";
      });
    } else if (_passwordController.text.length == 0) {
      setState(() {
        errorCode = true;
        loadingScreen = false;

        errorMessage = "يرجى إدخال كلمة السر";
      });
    } else {
      bool response = await LoginServices.loginAdmin(
          username: myController.text, password: _passwordController.text);
      if (response) {
        KammunRestart.restartApp(context);
      } else {
        setState(() {
          errorCode = true;
          loadingScreen = false;

          errorMessage = "خطأ بإسم المستخدم أو كلمة المرور";
        });
      }
    }
  }

  Future fetchOtp() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (myController.text.length != 10) {
      setState(() {
        errorCode = true;
        errorMessage = "يرجى إدخال رقم يتألف من عشرة خانات";
      });
    } else {
      try {
        setState(() {
          loadingScreen = true;
        });
        LoginScreen.supportedCityId = "1";

        await SmsAutoFill().listenForCode;

        String signature = await SmsAutoFill().getAppSignature;

        Tools.logToConsole(
            "Signature: ###################" + signature.toString());
        if (signature.toString().length != 11) {
          signature = "no";
        }
        bool response = await Services.loginUser(
            phoneNumber:
                LoginServices.replaceFarsiNumber(myController.text.toString()),
            signCode: signature,
            supportedCityId: "1");

        if (response) {
          await SmsAutoFill().listenForCode;
          setState(() {
            loadingScreen = false;
            LoginScreen.phoneNumber =
                LoginServices.replaceFarsiNumber(myController.text.toString());
          });
          Navigator.of(context)
              .pushReplacementNamed(OTPVerification.routeName, arguments: {
            "phone":
                LoginServices.replaceFarsiNumber(myController.text.toString())
          });
        } else {
          setState(() {
            loadingScreen = false;
            errorCode = true;
          });
        }
      } catch (e) {
        setState(() {
          loadingScreen = false;
          errorCode = true;
        });
        Tools.logToConsole("----------------- FEATCH OTP EXCEPTION ------");
        throw new Exception(e.toString());
      }
    }
  }

  Widget _ShowPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextField(
        textDirection: TextDirection.ltr,
        // maxLengthEnforced: true,
        // maxLength: 20,

        // keyboardType: TextInputType.multiline,
        maxLines: 1,
        controller: _passwordController,
        keyboardType: TextInputType.text,
        enableSuggestions: false,
        autocorrect: false,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "كلمة المرور",
          labelStyle: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk, fontSize: 30),
          hintStyle: TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: UtilsImporter().colorUtils.primarycolor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: UtilsImporter().colorUtils.kmColors,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget _ShowCountryInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextField(
        textDirection: TextDirection.ltr,

        // maxLengthEnforced: true,
        // maxLength: 20,

        // keyboardType: TextInputType.multiline,
        maxLines: 1,
        controller: myController,
        keyboardType: TextInputType.text,

        decoration: InputDecoration(
          labelText: "اسم المستخدم",
          labelStyle: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk, fontSize: 30),
          hintStyle: TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: UtilsImporter().colorUtils.primarycolor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: UtilsImporter().colorUtils.kmColors,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsImporter().colorUtils.kmColors,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AnimatedBackground(
              behaviour: RandomParticleBehaviour(),
              vsync: this,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.90,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(180),
                      // topRight: Radius.circular(180),
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).viewInsets.bottom != 0
                              ? 0
                              : 180),
                      bottomRight: Radius.circular(
                          MediaQuery.of(context).viewInsets.bottom != 0
                              ? 0
                              : 180),
                    )),
              ),
            ),
            errorCode
                ? AlertMessages(
                    text: "$errorMessage",
                    messageType: "internetError",
                    headerText: "مشكلة بالبيانات المدخلة",
                  )
                : Container(
                    padding: EdgeInsets.zero,
                  ),
            ListView(
              //    mainAxisAlignment: MainAxisAlignment.start,
              shrinkWrap: true,
              children: [
                Container(
                  //  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Image.asset(
                        "assets/kmlogoo.png",
                        height: 150,
                        width: 200,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 0, top: 5),
                  //  color: Colors.white,

                  child: _ShowCountryInput(),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 0, top: 5),
                  //  color: Colors.white,

                  child: _ShowPasswordInput(),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 5),
                  //  color: Colors.white,

                  child: loadingScreen
                      ? Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                          child: Loader(),
                        )
                      : KammunButton(
                          text: "تسجيل الدخول",
                          height: 50,
                          color: UtilsImporter().colorUtils.primarycolor,
                          onTap: adminLogin,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

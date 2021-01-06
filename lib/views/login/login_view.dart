import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/errors_screen/internet_error.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/OTPVerification.dart';
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

  ScrollController _scroll = new ScrollController();

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

  Future featchOtp() async {
    //Tools.logToConsole("^^^^^^^^^^ : " + myController.text.toString());
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

        Tools.logToConsole("input number : " + myController.text);
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

  @override
  Widget build(BuildContext context) {
    Widget _ShowCountryInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextField(
          maxLengthEnforced: true,
          maxLength: 10,

          // keyboardType: TextInputType.multiline,
          maxLines: 1,
          controller: myController,
          keyboardType: TextInputType.numberWithOptions(),

          decoration: InputDecoration(
            labelText: "رقم الموبايل",
            labelStyle: TextStyle(
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                fontSize: 30),
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

    Widget _showSubmit() {
      final GestureDetector loginButtonWithGesture = new GestureDetector(
        onTap: featchOtp,
        child: new Container(
          height: 50.0,
          decoration: new BoxDecoration(
              color: UtilsImporter().colorUtils.primarycolor,
              borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: new Center(
            child: new Text(
              "تأكيد رقم الموبايل",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk),
            ),
          ),
        ),
      );

      return loadingScreen
          ? Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
              child: Loader(),
            )
          : Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
              child: loginButtonWithGesture);
    }

    return Scaffold(
      backgroundColor: UtilsImporter().colorUtils.kmColors,
      //backgroundColor: Colors.white,
      // appBar: GradientAppBar(
      //   title: Text('Kammun.com'),
      //   backgroundColorStart: Colors.cyan,
      //   backgroundColorEnd: Colors.indigo,
      // ),
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
            ListView(
              ///   mainAxisAlignment: MainAxisAlignment.start,

              shrinkWrap: true,
              children: [
                errorCode
                    ? AlertMessages(
                        text: "$errorMessage",
                        messageType: "internetError",
                        headerText: "مشكلة بالبيانات المدخلة",
                      )
                    : Container(
                        padding: EdgeInsets.zero,
                      ),
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
                      left: 20.0, right: 20, bottom: 20, top: 5),
                  //  color: Colors.white,

                  child: _showSubmit(),
                )
                // Padding(
                //   padding: const EdgeInsets.only(top: 50.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Container(
                //         width: 60,
                //         height: 60,
                //         child: Icon(
                //           Icons.panorama_fish_eye_outlined,
                //           size: 20,
                //           color: Colors.white,
                //         ),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: UtilsImporter().colorUtils.primarycolor),
                //       ),
                //       Container(
                //         width: 60,
                //         height: 60,
                //         child: Icon(
                //           Icons.panorama_fish_eye_outlined,
                //           size: 20,
                //           color: Colors.white,
                //         ),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: UtilsImporter().colorUtils.primarycolor),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

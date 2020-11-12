import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/Loader.dart';

import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/errors_screen/internet_error.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/OTPVerification.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Services.dart';
import 'Services/login_services.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  static String phoneNumber = "";
  static String supportedCityId;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String currentText = "";
  final myController = TextEditingController();

  ScrollController _scroll = new ScrollController();

  bool errorCode = false;
  bool loadingScreen = false;
  String selectedValue;
  String errorMessage;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String firebaseToken;

  @override
  void initState() {
    if (LoadingScreenServices.supportedCitiesListIntro.length == 0) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new InternetError()));
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initializeNotificaiton(ctx: context));

    super.initState();
  }

  _initializeNotificaiton({BuildContext ctx}) {
    print("====== Starting initializing Firebase ======");
    //checkUpdate = _checkAppVersion();

    Future.delayed(const Duration(seconds: 0), () {
// Here you can write your code

      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      getoken();
      print("====== End initializing Firebase ======");
    });
  }

  Future getoken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.get("firebase_token") == null) {
    //   firebaseToken = await _firebaseMessaging.getToken();
    //   prefs.setString("firebase_token", firebaseToken);
    //   print("FFFFFFFFFFFFF TOKEN FFFFFFFFFFFFF  ");
    //   print(firebaseToken);
    // } else {
    //   print("FFFFFFFFFFFFF TOKEN FFFFFFFFFFFFF  ");

    //   print(prefs.get("firebase_token"));
    // }

    Future.delayed(const Duration(seconds: 100), () {
// Here you can write your code

      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      getoken();
      print("====== End initializing Firebase ======");
    });
  }

  void _showDialog(title, body) {
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

  Future featchOtp() async {
    //print("^^^^^^^^^^ : " + myController.text.toString());
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (myController.text.length != 10) {
      setState(() {
        errorCode = true;
        errorMessage = "يرجى إدخال رقم يتألف من عشرة خانات";
      });
    } else if (selectedValue == null) {
      setState(() {
        errorCode = true;
        errorMessage = "يرجى إختيار أقرب مدينة إليك";
      });
    } else {
      try {
        setState(() {
          loadingScreen = true;
        });
        LoginScreen.supportedCityId = selectedValue.split("id")[1];

        await SmsAutoFill().listenForCode;

        String signature = await SmsAutoFill().getAppSignature;

        print("input number : " + myController.text);
        print("Signature: ###################" + signature.toString());
        if (signature.toString().length != 11) {
          signature = "";
        }
        bool response = await Services.loginUser(
            phoneNumber:
                LoginServices.replaceFarsiNumber(myController.text.toString()),
            signCode: signature,
            supportedCityId: selectedValue.split("id")[1]);

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
        print(
            "---------------------------------- FEATCH OTP EXCEPTION ----------------------------------");
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

    Widget _showAddAddressButton() {
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
      backgroundColor: Theme.of(context).primaryColorLight,
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          controller: _scroll,
          child: Column(
            children: <Widget>[
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
                    padding: const EdgeInsets.only(
                        top: 20.0, right: 15, left: 15, bottom: 10),
                    child: Center(
                      child: Text(
                          "تحتاج لإدخال رقم هاتفك المحمول و اختيار أقرب مدينة إليك حتى تتمكن من استعمال تطبيق كمّون (هذا الإجراء فقط لمرة واحدة ) .",
                          style: TextStyle(
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 20,
                          )),
                    ),
                  ),
                  // width: double.infinity,
                  // height: MediaQuery.of(context).size.height,
                  color: Colors.white),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 5, color: UtilsImporter().colorUtils.kmColors),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchableDropdown(
                    style: TextStyle(
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    closeButton: "إغلاق",
                    isCaseSensitiveSearch: false,
                    underline: Container(),
                    isExpanded: true,
                    items: LoadingScreenServices.supportedCitiesListIntro,
                    value: selectedValue,
                    hint: new Text(
                      'يرجى اختيار اقرب مدينة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      ),
                    ),
                    searchHint: new Text(
                      'يرجى كتابة اسم المنطقة',
                      style: new TextStyle(
                          fontSize: 20,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                        print(value);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _ShowCountryInput(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _showAddAddressButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/login/OTPVerification.dart';
import 'package:kammun_app/views/login/policy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  String currentText = "";
  final myController = TextEditingController();

  bool errorCode = false;
  bool loadingScreen = false;
  String errorMessage = " يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت";

  @override
  void initState() {
    super.initState();
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

        if (signature.toString().length != 11) {
          signature = "";
        }
        bool response = await Services.loginUser(
            phoneNumber: LoginServices.replaceFarsiNumber(myController.text.toString()),
            signCode: signature,
            supportedCityId: "1");

        if (response) {
          await SmsAutoFill().listenForCode;
          setState(() {
            loadingScreen = false;
            LoginScreen.phoneNumber = LoginServices.replaceFarsiNumber(myController.text.toString());
          });
          Navigator.of(context).pushReplacementNamed(OTPVerification.routeName,
              arguments: {"phone": LoginServices.replaceFarsiNumber(myController.text.toString())});
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
        throw new Exception(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _showCountryInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: TextField(
          maxLengthEnforced: true,
          maxLength: 10,
          maxLines: 1,
          controller: myController,
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            labelText: "رقم الموبايل",
            labelStyle: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 30),
            hintStyle: TextStyle(color: Colors.black45),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorUtils.primaryColor,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorUtils.kmColors,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      );
    }

    void _settingModalBottomSheet(context) {
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: UsagePolicy(
            (approve) {
              if (approve) {
                Navigator.of(context).pop();
                fetchOtp();
              }
            },
          ),
        ),
      );
    }

    Widget _showSubmit() {
      final GestureDetector loginButtonWithGesture = new GestureDetector(
        onTap: () {
          _settingModalBottomSheet(context);
        },
        child: new Container(
          height: 50.0,
          decoration: new BoxDecoration(
              color: ColorUtils.primaryColor, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: new Center(
            child: new Text(
              "تأكيد رقم الموبايل",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: StringUtils.fontFamilyHKGrotesk),
            ),
          ),
        ),
      );

      return loadingScreen
          ? Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
              child: Loader(),
            )
          : Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
    }

    return Scaffold(
      backgroundColor: ColorUtils.kmColors,
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
                    bottomLeft: Radius.circular(MediaQuery.of(context).viewInsets.bottom != 0 ? 0 : 180),
                    bottomRight: Radius.circular(MediaQuery.of(context).viewInsets.bottom != 0 ? 0 : 180),
                  ),
                ),
              ),
            ),
            ListView(
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 0, top: 5),
                  child: _showCountryInput(),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
                  child: _showSubmit(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kammun_app/utils/Loader.dart';

import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/OTPVerification.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
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

  @override
  void initState() {
    super.initState();
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
          // onTap: _requestFocus,
          // focusNode: _focusNode,
          //cursorColor: Theme.of(ctx).cursorColor,

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
            // labelStyle: TextStyle(
            //     color: _focusNode.hasFocus ? Colors.orange : Colors.black),
            // labelText: _focusNode.hasFocus ? 'Your Address' : "",
          ),
        ),
        // child: new TextField(
        //   keyboardType: TextInputType.numberWithOptions(),
        //   cursorColor: UtilsImporter().colorUtils.kmColors,
        //   maxLines: 1,
        //   textInputAction: TextInputAction.next,
        //   controller: myController,
        //   style: new TextStyle(
        //       fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        //       fontWeight: FontWeight.w500,
        //       fontSize: 16.0,
        //       color: Theme.of(context).primaryColorDark),
        //   decoration: InputDecoration(
        //     enabledBorder: UnderlineInputBorder(
        //       borderSide:
        //           BorderSide(color: UtilsImporter().colorUtils.primarycolor),
        //     ),
        //     border: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         color: UtilsImporter().colorUtils.primarycolor,
        //       ),
        //       borderRadius: BorderRadius.circular(5.0),
        //     ),
        //     focusedBorder: UnderlineInputBorder(
        //       borderSide:
        //           BorderSide(color: UtilsImporter().colorUtils.primarycolor),
        //     ),
        //     hintText: LoadingScreenServices.companyInformation.phone,
        //     hintStyle: TextStyle(
        //         color: Colors.black26,
        //         fontSize: 15,
        //         fontFamily: UtilsImporter().stringUtils.HKGrotesk),
        //     labelText: "رقم الموبايل",
        //     labelStyle: TextStyle(
        //       fontSize: 25,
        //       color: UtilsImporter().colorUtils.greycolor,
        //       fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        //     ),
        //     // border: new UnderlineInputBorder(
        //     //     borderSide: new BorderSide(
        //     //         color: UtilsImporter().colorUtils.primarycolor)
        //     //         )
        //   ),
        // ),
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

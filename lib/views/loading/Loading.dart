import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/cartModel.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/errors_screen/internet_error.dart';
import 'package:kammun_app/views/home/home_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/server_update/server_update.dart';
import 'package:kammun_app/views/update_screen/updateRequiredScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  static String user_token = "Bearer ";
  static String updateUrl = "";
  static String androidShareUrl = "";
  static String iOSShareUrl = "";

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future featchInformation;
  Future checkUpdate;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future getFirebaseToken;
  String firebaseToken;
  CartProduct cartLoad = CartProduct();

  dynamic notificationValue;

  @override
  void initState() {
    super.initState();

    featchInformation = _getClientInfo();
    //checkUpdate = _checkAppVersion();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];

        print(notification['title']);
        print(notification['body']);
        print("--------- the data route_name is -------");
        print(message['data']['route_name']);

        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);

        // if (message['data']['route_name'] == "/productDetails") {

        // }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        print(notification['title']);
        print(notification['body']);
        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);

        notificationValue = notification;
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];
        print("onResume: $message");
        // Navigator.push(
        //     context, new MaterialPageRoute(builder: (context) => HomeView(2)));

        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    getFirebaseToken = getoken();
  }

  Future getoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("firebase_token") == null) {
      firebaseToken = await _firebaseMessaging.getToken();
      prefs.setString("firebase_token", firebaseToken);
      print("FFFFFFFFFFFFF TOKEN FFFFFFFFFFFFF  ");
      print(firebaseToken);
    }
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

  _getClientInfo() async {
    bool userLoggedIn = await LoadingScreenServices().checkIfUserloddedIn();
    if (userLoggedIn) {
      bool x = await LoadingScreenServices().featchStartInformation();
      if (x) {
        return true;
      } else {
        return false;
      }
    } else {
      // check application version //
      // get supported cities //
      await LoadingScreenServices().getSupportedCity();
      return "userNotLoggedIn";
    }
  }

  loadingProgress() {
    return Scaffold(
      backgroundColor: UtilsImporter().colorUtils.kmColors,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/welcome_screen.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Stack(children: <Widget>[
          Positioned(
            left: MediaQuery.of(context).size.width - 80,
            bottom: MediaQuery.of(context).size.height / 2 - 37,
            height: 100,
            width: 100,
            child: Image.asset(
              "assets/Loading.gif",
              // width: 20,
              // color: Colors.transparent,
            ),
          ),
        ]),
      ),
    );
  }

  navigateToHome() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFirebaseToken,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return FutureBuilder(
              future: featchInformation,
              builder: (context, snapShot) {
                // print("---------- THE SNAPSHOT ----------");
                if (snapShot.data == "userNotLoggedIn") {
                  return LoginScreen();
                }

                if (snapShot.connectionState == ConnectionState.done) {
                  if (snapShot.hasError) return InternetError();
                  if (LoadingScreenServices.updateRequired)
                    return UpdateScreen();
                  if (LoadingScreenServices.serverMaintain)
                    return ServerUpdate();
                  return AnimatedSwitcher(
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end);
                      var curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      );

                      return SlideTransition(
                        position: tween.animate(curvedAnimation),
                        child: HomeView(
                          routeIndex: 0,
                          notificationValue: notificationValue,
                        ),
                      );
                    },
                    duration: Duration(milliseconds: 250),
                    child: HomeView(
                      routeIndex: 0,
                      notificationValue: notificationValue,
                    ),
                  );
                } else {
                  return loadingProgress();
                }
              });
        } else {
          return loadingProgress();
        }
      },
    );
  }
}

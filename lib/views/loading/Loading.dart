import 'package:flutter/material.dart';
import 'package:kammun_app/models/cartModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/blocked_user/blocked_user.dart';
import 'package:kammun_app/views/errors_screen/internet_error.dart';
import 'package:kammun_app/views/home/home_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/server_update/server_update.dart';
import 'package:kammun_app/views/supported_city/supported_city.dart';
import 'package:kammun_app/views/update_screen/updateRequiredScreen.dart';

class LoadingScreen extends StatefulWidget {
  static String userToken = "Bearer ";
  static String updateUrl = "";
  static bool isAdmin = false;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future fetchInformation;
  Future checkUpdate;

  CartProduct cartLoad = CartProduct();

  dynamic notificationValue;

  @override
  void initState() {
    fetchInformation = _getClientInfo();

    super.initState();
  }

  _getClientInfo() async {
    bool userLoggedIn = await LoadingScreenServices().checkIfUserLoadedIn();
    // if (userLoggedIn == null) return "userNotSelectSupportedCity";
    if (userLoggedIn) {
      bool x = await LoadingScreenServices().fetchStartInformation();
      if (x) {
        return true;
      } else {
        return false;
      }
    } else {
      // check application version //
      // get supported cities //
      //  LoadingScreenServices().getSupportedCity();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchInformation,
      builder: (context, snapShot) {
        // Tools.logToConsole("---------- THE SNAPSHOT ----------");
        if (snapShot.data == "userNotLoggedIn") {
          return LoginScreen();
        }
        if (snapShot.data == "userNotSelectSupportedCity") {
          return SupportedCityWidget();
        }

        if (snapShot.connectionState == ConnectionState.done) {
          if (snapShot.hasError || snapShot.data == false) {
            return InternetError();
          } else if (LoadingScreenServices.updateRequired) {
            return UpdateScreen();
          } else if (LoadingScreenServices.serverMaintain) {
            return ServerUpdate();
          } else if (LoadingScreenServices.userBlocked) {
            return BlockedUser();
          } else {
            return AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
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
          }
        } else {
          return loadingProgress();
        }
      },
    );
  }
}

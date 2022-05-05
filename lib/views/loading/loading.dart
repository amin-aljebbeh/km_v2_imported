import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/blocked_user/blocked_user.dart';
import 'package:kammun_app/views/errors_screen/internet_error.dart';
import 'package:kammun_app/views/home/home_view.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/server_update/server_update.dart';
import 'package:kammun_app/views/supported_city/supported_city.dart';
import 'package:kammun_app/views/update_screen/update_required_screen.dart';

class LoadingScreen extends StatefulWidget {
  static String userToken = "Bearer ";
  static String updateUrl = "";

  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future fetchInformation;

  dynamic notificationValue;

  @override
  void initState() {
    fetchInformation = _getClientInfo();

    super.initState();
  }

  _getClientInfo() async {
    await Firebase.initializeApp();
    bool userLoggedIn = await LoadingScreenServices().checkIfUserLoggedIn();
    if (userLoggedIn == null) return "userNotSelectSupportedCity";
    if (userLoggedIn) {
      bool x = await LoadingScreenServices().fetchStartInformation();
      if (x) {
        return true;
      } else {
        return false;
      }
    } else {
      return "userNotLoggedIn";
    }
  }

  loadingProgress() {
    return Scaffold(
      backgroundColor: ColorUtils.kmColors,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/welcome_screen.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: MediaQuery.of(context).size.width - 80,
              bottom: MediaQuery.of(context).size.height / 2 - 37,
              height: 100,
              width: 100,
              child: Image.asset(
                "assets/Loading.gif",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchInformation,
        builder: (context, snapShot) {
          if (snapShot.data == "userNotLoggedIn") {
            return const LoginScreen();
          }
          if (snapShot.data == "userNotSelectSupportedCity") {
            return const SupportedCityView();
          }

          if (snapShot.connectionState == ConnectionState.done) {
            if (snapShot.hasError || snapShot.data == false) {
              return const InternetError();
            } else if (LoadingScreenServices.updateRequired) {
              return const UpdateScreen();
            } else if (LoadingScreenServices.serverMaintain) {
              return const ServerUpdate();
            } else if (LoadingScreenServices.userBlocked) {
              return const BlockedUser();
            } else {
              return AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  var begin = const Offset(0.0, 1.0);
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
                duration: const Duration(milliseconds: 250),
                child: HomeView(
                  routeIndex: 0,
                  notificationValue: notificationValue,
                ),
              );
            }
          } else {
            return loadingProgress();
          }
        });
  }
}

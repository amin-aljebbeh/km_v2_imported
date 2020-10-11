import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kammun_app/utils/common_utils.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/home/home_view.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/thank_you/thank_you_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'views/cart/CartViewFinal.dart';
import 'views/login/OTPVerification.dart';
import 'dart:ui' as ui;
import 'views/profile/profileScreen.dart';
import 'views/restart/kammunapp_restart.dart';
import 'views/server_update/server_update.dart';

void main() {
  //BlocSupervisor.delegate = SimpleBlocDelegate();
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(
    KammunRestart(
      child: CustomTheme(
        initialThemeKey: MyThemeKeys.LIGHT,
        child: MyApp(),
      ),
    ),
  );
}

class RestartWidget {}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // Future getFirebaseToken;
  // String firebaseToken;

  @override
  void initState() {
    super.initState();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     final notification = message['notification'];

    //     print(notification['title']);
    //     print(notification['body']);

    //     setState(() {

    //     });

    //      Navigator.push(
    //         context, new MaterialPageRoute(builder: (context) => HomeView(2)));

    //     // Navigator.pushNamed(context, '/home');

    //     _showDialog(notification['body']);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     final notification = message['data'];
    //     print(notification['title']);
    //     print(notification['body']);
    //     Navigator.pushNamed(context, '/home');

    //     // _showDialog(notification['body']);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     final notification = message['data'];
    //     print("onResume: $message");
    //     Navigator.pushNamed(context, '/home');

    //     // _showDialog(notification['body']);
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));

    // getFirebaseToken = getoken();
  }

  // void _showDialog(value) {
  //   AlertDialog alertDialog = new AlertDialog(
  //     content: new Container(
  //       height: 400.0,
  //       child: new Column(
  //         children: <Widget>[
  //           new Text(
  //             "MyCompany:",
  //           ),
  //           new Text(
  //             "$value",
  //           ),
  //           new Padding(padding: EdgeInsets.all(20.0)),
  //           new RaisedButton(
  //             child: new Text("OK"),
  //             onPressed: () => Navigator.pop(context),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(context: context, child: alertDialog);
  // }

  // Future getoken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.get("firebase_token") == null) {
  //     firebaseToken = await _firebaseMessaging.getToken();
  //     prefs.setString("firebase_token", firebaseToken);
  //     print("FFFFFFFFFFFFF TOKEN FFFFFFFFFFFFF  ");
  //     print(firebaseToken);
  //   }
  // }

  loadingProgress(BuildContext context) {
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

  Widget build(BuildContext context) {
    return KammunRestart(
        child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            supportedLocales: [
              Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales
            ],
            locale: Locale("ar", "AE"),
            title: 'Kammun',
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              LoginScreen.routeName: (_) => LoginScreen(),
              //  '/login': (_) => new LoginView(), // Login Page
              '/home': (_) => HomeView(routeIndex: 0),
              '/myApp': (_) => MyApp(),
              'loading': (_) => LoadingScreen(),
              // '/home': (_) => LoginView(),
              '/favoraites': (_) => HomeView(routeIndex: 3),
              '/cartFinal': (_) => CartViewFinal(),
              OTPVerification.routeName: (_) => OTPVerification(),
              ServerUpdate.routeName: (_) => ServerUpdate(),
              '/thankyou': (_) => new ThankYouView(),
              '/delivery': (_) => DeliverToView(),
              '/cart': (_) => new HomeView(routeIndex: 1),
              '/cartFromUpdate': (_) => new HomeView(
                    routeIndex: 1,
                    isFromUpdateOrder: true,
                  ),

              '/orders': (_) => HomeView(routeIndex: 2),
              '/profile': (_) => ProfileScreen(),
            },
            theme: CustomTheme.of(context),
            home: LoadingScreen()));
  }
}

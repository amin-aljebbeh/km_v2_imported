import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/home/home_view.dart';
import 'package:kammun_app/views/loading/loading.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:kammun_app/views/supported_city/supported_city.dart';
import 'package:kammun_app/views/thank_you/thank_you_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import 'views/login/otp_verification.dart';
import 'dart:ui' as ui;
import 'views/profile/profile_screen.dart';
import 'views/restart/kammunapp_restart.dart';
import 'views/server_update/server_update.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await VChatController.instance.init(
      baseUrl: Uri.parse("http://90.153.255.31"),
      appName: "Kammun",
      vChatNotificationType: VChatNotificationType.none,
      //widgetsBuilder: VChatCustomWidgets(),

      enableLogger: true,
      maxMediaUploadSize: 50 * 1000 * 1000,
      passwordHashKey: "sdgsdfgdfghtyh56756urtyjrtyj56ru567thjtyfg45645yrtyujj",
      maxGroupChatUsers: 512,
    );

    VChatController.instance.setLocaleMessages(vChatAddLanguageModel: [
      //pass your language
      VChatAddLanguageModel(
        languageCode: "ar",
        countryCode: "AE",
        lookupMessages: ArLanguage(),
      ),
    ]);
  } catch (e) {
    /**/
  }
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(
    const KammunRestart(
      child: CustomTheme(
        initialThemeKey: MyThemeKeys.light,
        child: MyApp(),
      ),
    ),
  );
}

class RestartWidget {}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  loadingProgress(BuildContext context) {
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
    return KammunRestart(
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale: const Locale("ar", "AE"),
        title: 'Kammun',
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          LoginScreen.routeName: (_) => const LoginScreen(),
          '/home': (_) => const HomeView(routeIndex: 0),
          '/myApp': (_) => const MyApp(),
          'loading': (_) => const LoadingScreen(),
          '/favoraites': (_) => const HomeView(routeIndex: 3),
          OTPVerification.routeName: (_) => const OTPVerification(),
          ServerUpdate.routeName: (_) => const ServerUpdate(),
          '/supportedCity': (_) => const SupportedCityView(),
          '/thankyou': (_) => const ThankYouView(),
          '/delivery': (_) => const DeliverToView(),
          '/cart': (_) => const HomeView(routeIndex: 1),
          '/cartFromUpdate': (_) =>
              const HomeView(routeIndex: 1, isFromUpdateOrder: true),
          '/orders': (_) => const HomeView(routeIndex: 2),
          '/profile': (_) => const ProfileScreen(),
        },
        theme: CustomTheme.of(context),
        home: const LoadingScreen(),
      ),
    );
  }
}

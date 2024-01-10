import 'dart:ui' as ui;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

import 'core/core_importer.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inject();
  final Store<AppState> store = AppRedux.init();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FirebaseAnalytics.instance.logEvent(name: 'Kammun');


  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(OverlaySupport(
    child: StoreProvider(
        store: store,
        child: CustomTheme(
            initialThemeKey: MyThemeKeys.light,
            child: KammunRestart(child: MyApp(store: store)))),
  ));
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;

  const MyApp({Key key, this.store}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget child) {
        return StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          distinct: true,
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              supportedLocales: const [Locale('ar', 'AE')],
              locale: const Locale('ar', 'AE'),
              title: 'Kammun',
              debugShowCheckedModeBanner: false,
              routes: routes,
              theme: CustomTheme.of(context),
              home: const LoadingScreen(),
            );
          },
        );
      },
    );
  }
}

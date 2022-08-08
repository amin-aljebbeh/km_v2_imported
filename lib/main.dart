import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_review_play_store/in_app_review_play_store.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:ui' as ui;
import 'core/core_importer.dart';
import 'modules/authentication/view/blocked_user.dart';
import 'modules/authentication/view/login_view.dart';
import 'modules/authentication/view/otp_verification.dart';
import 'modules/cart/view/cart_view.dart';
import 'modules/error/view/internet_error.dart';
import 'modules/map/view/kammun_map.dart';
import 'modules/notifications/firebase_init_page.dart';
import 'modules/orders/view/orders_view.dart';
import 'modules/profile/view/profile_screen.dart';

Future<void> main() async {
  final Store<AppState> store = AppRedux.init();
  try {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      InAppReview.init();
    }
    RenderErrorBox.backgroundColor = Colors.transparent;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  } catch (e) {
    /**/
  }
  runApp(StoreProvider(
      store: store,
      child: OverlaySupport(
          child: CustomTheme(
              initialThemeKey: MyThemeKeys.light, child: RestartWidget(child: FirebaseInitPage(store: store))))));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) => MaterialApp(
        navigatorKey: navigatorKey,
        color: Colors.white,
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
        routes: <String, WidgetBuilder>{
          LoginScreen.routeName: (_) => const LoginScreen(),
          StoreView.routeName: (_) => const HomeView(index: 0),
          PaymentView.routeName: (_) => const PaymentView(),
          GoToBank.routeName: (_) => const GoToBank(),
          PaymentFailedView.routeName: (_) => const PaymentFailedView(),
          WaitingPaymentView.routeName: (_) => const WaitingPaymentView(),
          '/myApp': (_) => const MyApp(),
          OTPVerification.routeName: (_) => const OTPVerification(),
          ServerUpdate.routeName: (_) => const ServerUpdate(),
          ThankYouView.routeName: (_) => const ThankYouView(),
          CartView.routeName: (_) => const HomeView(index: 1),
          OrdersView.routeName: (_) => const HomeView(index: 2),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
          AddAddressView.routeName: (_) => const AddAddressView(),
          BlockedUserView.routeName: (_) => const BlockedUserView(),
          InternetError.routeName: (_) => const InternetError(),
          UpdateScreen.routeName: (_) => const UpdateScreen(),
          LoadingScreen.routeName: (_) => const LoadingScreen(),
          InvoiceView.routeName: (_) => const InvoiceView(),
          MyAddresses.routeName: (_) => const MyAddresses(),
          OrderProblemView.routeName: (_) => const OrderProblemView(),
          KammunMapView.routeName: (_) => const KammunMapView(),
        },
        theme: CustomTheme.of(context),
        home: const LoadingScreen(),
      ),
    );
  }
}

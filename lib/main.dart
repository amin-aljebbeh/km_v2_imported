import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'views/deliver_to/deliver_to_view.dart';
import 'views/home/home_view.dart';
import 'views/loading/Loading.dart';
import 'views/login/login_view.dart';
import 'views/reports/reports.dart';
import 'views/supported_city/supported_city.dart';
import 'views/thank_you/thank_you_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'views/cart/CartViewFinal.dart';
import 'views/inventory/inventory_importer.dart';
import 'views/login/OTPVerification.dart';
import 'dart:ui' as ui;
import 'views/prices_changes/prices.dart';
import 'views/products_attached_to_warehouse/views/products_attached_to_warehouse_importer.dart';
import 'views/profile/profileScreen.dart';
import 'views/reports/reports_importer.dart';
import 'views/restart/kammunapp_restart.dart';
import 'views/server_update/server_update.dart';
import 'utils/utils_importer.dart';

void main() {
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
          '/home': (_) => HomeView(routeIndex: 0),
          '/myApp': (_) => MyApp(),
          'loading': (_) => LoadingScreen(),
          '/favoraites': (_) => HomeView(routeIndex: 3),
          '/cartFinal': (_) => CartViewFinal(),
          OTPVerification.routeName: (_) => OTPVerification(),
          ServerUpdate.routeName: (_) => ServerUpdate(),
          '/supportedCity': (_) => SupportedCityWidget(),
          '/thankyou': (_) => new ThankYouView(),
          '/delivery': (_) => DeliverToView(),
          '/cart': (_) => new HomeView(routeIndex: 1),
          '/cartFromUpdate': (_) => new HomeView(
                routeIndex: 1,
                isFromUpdateOrder: true,
              ),
          '/orders': (_) => HomeView(routeIndex: 2),
          '/profile': (_) => ProfileScreen(),
          '/statistics': (_) => DailyStatistics(),
          '/sales_reports': (_) => SalesReport(),
          '/products_added_to_warehouse': (_) => AddedProductsToWarehouse(),
          '/products_not_added_to_warehouse': (_) => NotAddedProductsToWarehouse(),
          '/all_products': (_) => AllProducts(),
          '/attach_product_to_sub_warehouse': (_) => AddProductsToSubWarehouse(),
          '/matching_report': (_) => MatchingReport(),
          '/subWarehouseManagement': (_) => GetSubWarehouse(),
          '/priceChange': (_) => Prices(),
          '/Inventory': (_) => Inventory(),
          '/AccountantTransactionView': (_) => AccountantTransactionView(),
          '/ShopperTransactionView': (_) => ShopperTransactionView(),
          '/AddTransactionView': (_) => AddTransactionView(),
          '/products_filter': (_) => ProductsFilterScreen(),
          '/SupplierAccounts': (_) => SupplierAccounts(),
          '/ShopperManagementView': (_) => ShopperManagementView(),
        },
        theme: CustomTheme.of(context),
        home: LoadingScreen(),
      ),
    );
  }
}

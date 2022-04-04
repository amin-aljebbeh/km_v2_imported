import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'utils/utils_importer.dart';
import 'views/cart/CartViewFinal.dart';
import 'views/home/home_view.dart';
import 'views/inventory/inventory_importer.dart';
import 'views/loading/Loading.dart';
import 'views/login/login_view.dart';
import 'views/prices_changes/prices.dart';
import 'views/products_attached_to_warehouse/views/products_attached_to_warehouse_importer.dart';
import 'views/profile/profileScreen.dart';
import 'views/reports/reports_importer.dart';
import 'views/restart/kammunapp_restart.dart';
import 'views/server_update/server_update.dart';
import 'views/thank_you/thank_you_view.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
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
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final home = HomeView(routeIndex: 0);
    final cart = HomeView(routeIndex: 1);
    final cartFromUpdate = HomeView(routeIndex: 1, isFromUpdateOrder: true);
    final orders = HomeView(routeIndex: 2);
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
          '/home': (_) => home,
          '/myApp': (_) => const MyApp(),
          'loading': (_) => const LoadingScreen(),
          '/cartFinal': (_) => const CartViewFinal(),
          ServerUpdate.routeName: (_) => const ServerUpdate(),
          '/thankyou': (_) => const ThankYouView(),
          '/cart': (_) => cart,
          '/cartFromUpdate': (_) => cartFromUpdate,
          '/orders': (_) => orders,
          '/profile': (_) => const ProfileScreen(),
          '/statistics': (_) => const DailyStatistics(),
          '/sales_reports': (_) => const SalesReport(),
          '/products_added_to_warehouse': (_) => const AddedProductsToWarehouse(),
          '/products_not_added_to_warehouse': (_) => const NotAddedProductsToWarehouse(),
          '/all_products': (_) => const AllProducts(),
          '/attach_product_to_sub_warehouse': (_) => const AddProductsToSubWarehouse(),
          '/subWarehouseManagement': (_) => const GetSubWarehouse(),
          '/priceChange': (_) => const Prices(),
          '/Inventory': (_) => const Inventory(),
          '/AccountantTransactionView': (_) => const AccountantTransactionView(),
          '/ShopperTransactionView': (_) => const ShopperTransactionView(),
          '/AddTransactionView': (_) => AddTransactionView(),
          '/products_filter': (_) => const ProductsFilterScreen(),
          '/SupplierAccounts': (_) => const SupplierAccounts(),
          '/ShopperManagementView': (_) => const ShopperManagementView(),
        },
        theme: CustomTheme.of(context),
        home: const LoadingScreen(),
      ),
    );
  }
}

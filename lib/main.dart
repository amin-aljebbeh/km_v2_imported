import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/cart/cart_view_final.dart';
import 'views/home/home_view.dart';
import 'views/loading/loading.dart';
import 'views/login/login_view.dart';
import 'views/prices_changes/prices.dart';
import 'views/profile/profile_screen.dart';
import 'views/restart/kammunapp_restart.dart';
import 'views/server_update/server_update.dart';
import 'views/thank_you/thank_you_view.dart';
import 'core/core_importer.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e) {
    /**/
  }

  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(const KammunRestart(child: CustomTheme(initialThemeKey: MyThemeKeys.light, child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return KammunRestart(
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
          '/home': (_) => const HomeView(routeIndex: 0),
          '/myApp': (_) => const MyApp(),
          'loading': (_) => const LoadingScreen(),
          '/cartFinal': (_) => const CartViewFinal(),
          ServerUpdate.routeName: (_) => const ServerUpdate(),
          ShopperMonthReport.routeName: (_) => const ShopperMonthReport(),
          ShopperWorkingHoursView.routeName: (_) => const ShopperWorkingHoursView(),
          ActivityHoursView.routeName: (_) => const ActivityHoursView(),
          '/thankyou': (_) => const ThankYouView(),
          '/cart': (_) => const HomeView(routeIndex: 1),
          '/cartFromUpdate': (_) => const HomeView(routeIndex: 1, isFromUpdateOrder: true),
          '/orders': (_) => const HomeView(routeIndex: 2),
          '/profile': (_) => const ProfileScreen(),
          '/sales_reports': (_) => const SalesReport(),
          '/sales_charts': (_) => const SalesCharts(),
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
          '/financial_report_view': (_) => const FinancialReportView(),
        },
        theme: CustomTheme.of(context),
        home: const LoadingScreen(),
      ),
    );
  }
}

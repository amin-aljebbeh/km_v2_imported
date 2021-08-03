import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/favoraites/favoraites.dart';
import 'package:kammun_app/views/inventory/inventory.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/prices_changes/prices.dart';
import 'package:kammun_app/views/products_view/add_products.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  dynamic notificationValue;

  HomeView(
      {this.routeIndex,
      this.isFromUpdateOrder = false,
      this.notificationValue});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState(routeIndex, isFromUpdateOrder);
  }
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex;
  bool _isFromUpdateOrder;
  HomeViewState(this._selectedIndex, this._isFromUpdateOrder);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String firebaseToken;

  @override
  void initState() {
    widget.notificationValue != null
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _showNotificationDialog(ctx: context))
        : {};

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initializeNotificaiton(ctx: context));
    super.initState();
  }

  _initializeNotificaiton({BuildContext ctx}) {
    Tools.logToConsole("====== Starting initializing Firebase ======");
    //checkUpdate = _checkAppVersion();

// Here you can write your code
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Tools.logToConsole("onMessage: $message");
        final notification = message['notification'];

        Tools.logToConsole(notification['title']);
        Tools.logToConsole(notification['body']);
        Tools.logToConsole("--------- the data route_name is -------");
        Tools.logToConsole(message['data']['route_name']);

        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);

        // if (message['data']['route_name'] == "/productDetails") {

        // }
      },
      onLaunch: (Map<String, dynamic> message) async {
        Tools.logToConsole("onLaunch: $message");
        final notification = message['data'];
        Tools.logToConsole(notification['title']);
        Tools.logToConsole(notification['body']);
        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);

        widget.notificationValue = notification;
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];
        Tools.logToConsole("onResume: $message");
        // Navigator.push(
        //     context, new MaterialPageRoute(builder: (context) => HomeView(2)));

        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    getoken();
    Tools.logToConsole("====== End initializing Firebase ======");
  }

  Future getoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("firebase_token") == null) {
      firebaseToken = await _firebaseMessaging.getToken();
      prefs.setString("firebase_token", firebaseToken);
      Tools.logToConsole("FF firebase from firebase FF");
      Tools.logToConsole(firebaseToken);
      LoadingScreenServices().updateFirebaseToken(firebaseToken);
    } else {
      Tools.logToConsole("FF firebase from sharedPref FF");
      Tools.logToConsole(prefs.get("firebase_token"));
      firebaseToken = prefs.get("firebase_token");
    }
    // if (LoadingScreenServices.userOriginal.data.firebaseToken !=
    //     firebaseToken) {
    //   LoadingScreenServices().updateFirebaseToken(firebaseToken);
    //   Tools.logToConsole("Firebase Updated");
    // }
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

  _showNotificationDialog({BuildContext ctx}) {
    String title = widget.notificationValue["title"];
    String body = widget.notificationValue["body"];
    showDialog(
      context: ctx,
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

  Widget _buttomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> buttomList = [];

    buttomList.add(
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.store,
            // color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(Icons.store, color: Color.fromARGB(255, 53, 99, 124)),
          title: Text(
            UtilsImporter().stringUtils.store,
            style: TextStyle(
                color: Color.fromARGB(255, 53, 99, 124),
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                fontSize: 15),
          )),
    );
    buttomList.add(
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.shopping_cart,
            // color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(Icons.shopping_cart,
              color: Color.fromARGB(255, 53, 99, 124)),
          title: Text(
            UtilsImporter().stringUtils.cart,
            style: TextStyle(
                color: Color.fromARGB(255, 53, 99, 124),
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                fontSize: 15),
          )),
    );
    if (LoadingScreenServices.viewOrderPermission) {
      buttomList.add(
        BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.reorder,
              //color: Theme.of(context).primaryColor,
              color: Color.fromARGB(255, 210, 178, 2),
            ),
            icon: Icon(Icons.reorder, color: Color.fromARGB(255, 53, 99, 124)),
            title: Text(
              UtilsImporter().stringUtils.orders,
              style: TextStyle(
                  color: Color.fromARGB(255, 53, 99, 124),
                  fontWeight: FontWeight.w500,
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                  fontSize: 15),
            )),
      );
    }
    if (LoadingScreenServices.productsOperationPermission) {
      buttomList.add(
        BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.category,
              // color: Theme.of(context).primaryColor,
              color: Color.fromARGB(255, 210, 178, 2),
            ),
            icon: Icon(Icons.category, color: Color.fromARGB(255, 53, 99, 124)),
            title: Text(
              "جرد منتجات",
              style: TextStyle(
                  color: Color.fromARGB(255, 53, 99, 124),
                  fontWeight: FontWeight.w500,
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                  fontSize: 15),
            )),
      );
    }
    if (LoadingScreenServices.isSuperAdmin) {
      buttomList.add(BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.money_off_csred_outlined,
            // color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(Icons.money_off_csred_outlined,
              color: Color.fromARGB(255, 53, 99, 124)),
          title: Text(
            "الأسعار",
            style: TextStyle(
                color: Color.fromARGB(255, 53, 99, 124),
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                fontSize: 15),
          )));
    }

    return BottomNavigationBar(
      // backgroundColor: Color.fromARGB(255, 53, 99, 124),
      //backgroundColor: Color.fromARGB(255, 57, 107, 137),
      backgroundColor: Colors.white,
      items: buttomList,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.white,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _tabs = [];
    _tabs.add(StoreView());
    _tabs.add(CartView(
      isFromUpdateOrder: _isFromUpdateOrder,
    ));

    if (LoadingScreenServices.viewOrderPermission) {
      _tabs.add(OrdersView());
    }
    if (LoadingScreenServices.productsOperationPermission) {
      _tabs.add(Inventory());
    }

    if (LoadingScreenServices.isSuperAdmin) {
      _tabs.add(Prices());
    }

    return Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: _buttomNavBar(context: context));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isFromUpdateOrder = false;
    });
  }
}

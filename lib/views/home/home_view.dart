import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/favoraites/favoraites.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  final dynamic notificationValue;

  HomeView({this.routeIndex, this.isFromUpdateOrder = false, this.notificationValue});

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
        ? WidgetsBinding.instance.addPostFrameCallback((_) => _showNotificationDialog(ctx: context))
        : Tools.logToConsole('');

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeNotification(ctx: context));
    super.initState();
  }

  _initializeNotification({BuildContext ctx}) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['notification'];

        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['data'];

        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);

        if (LoadingScreenServices.showOnLunchNotification)
          _showDialog(notification['title'], notification['body']);
        LoadingScreenServices.showOnLunchNotification = false;
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];

        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);

        _showDialog(notification['title'], notification['body']);
      },
    );
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    getToken();
  }

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("firebase_token") == null) {
      firebaseToken = await _firebaseMessaging.getToken();
      prefs.setString("firebase_token", firebaseToken);
    } else {
      firebaseToken = prefs.get("firebase_token");
    }
    if (LoadingScreenServices.userOriginal.data.firebaseToken != firebaseToken) {
      LoadingScreenServices().updateFirebaseToken(firebaseToken);
    }
  }

  void _showDialog(title, body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: new Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
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
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: new Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
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

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      StoreView(),
      CartView(
        isFromUpdateOrder: _isFromUpdateOrder,
      ),
      OrdersView(),
      Favoraites(),
    ];
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.store,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(Icons.store, color: Color.fromARGB(255, 53, 99, 124)),
              // ignore: deprecated_member_use
              title: Text(
                StringUtils.store,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                    fontSize: 15),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 53, 99, 124)),
              // ignore: deprecated_member_use
              title: Text(
                StringUtils.cart,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                    fontSize: 15),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.reorder,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(Icons.reorder, color: Color.fromARGB(255, 53, 99, 124)),
              // ignore: deprecated_member_use
              title: Text(
                StringUtils.orders,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                    fontSize: 15),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 53, 99, 124),
              ),
              // ignore: deprecated_member_use
              title: Text(
                StringUtils.favorite,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                    fontSize: 15),
              )),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isFromUpdateOrder = false;
    });
  }
}

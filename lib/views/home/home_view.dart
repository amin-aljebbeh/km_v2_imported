import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/favoraites/favoraites.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:kammun_app/views/widget/dialog_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  int routeIndex;
  bool isFromUpdateOrder;
  final dynamic notificationValue;

  HomeView({Key key, this.routeIndex, this.isFromUpdateOrder = false, this.notificationValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (message.data['route_name'] != null) Navigator.pushNamed(context, message.data['route_name']);

      _showDialog(notification.title, notification.body);
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
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
      LoadingScreenServices().updateFirebaseTokenService(firebaseToken);
    }
  }

  void _showDialog(title, body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "$title",
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            DialogButton(
                text: StringUtils.close,
                onTap: () {
                  Navigator.of(context).pop();
                }),
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
          title: Text(
            title,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: Text(
            body,
            // maxLines: 20,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            DialogButton(
                text: StringUtils.close,
                onTap: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      const StoreView(),
      CartView(
        isFromUpdateOrder: widget.isFromUpdateOrder,
      ),
      const OrdersView(),
      const Favoraites(),
    ]; /*Color.fromARGB(255, 53, 99, 124)*/
    return Scaffold(
      body: _tabs[widget.routeIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                const Icon(
                  Icons.store,
                  color: Color.fromARGB(255, 210, 178, 2),
                ),
                Text(
                  StringUtils.store,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 53, 99, 124),
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 15),
                ),
              ],
            ),
            icon: Column(
              children: [
                const Icon(
                  Icons.store,
                  color: Color.fromARGB(255, 53, 99, 124),
                ),
                Text(
                  StringUtils.store,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 53, 99, 124),
                      // fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 15),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: Color.fromARGB(255, 210, 178, 2),
                ),
                Text(
                  StringUtils.cart,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 53, 99, 124),
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 15),
                ),
              ],
            ),
            icon: Column(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: Color.fromARGB(255, 53, 99, 124),
                ),
                Text(
                  StringUtils.cart,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 53, 99, 124),
                      // fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 15),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              activeIcon: Column(
                children: [
                  const Icon(
                    Icons.reorder,
                    color: Color.fromARGB(255, 210, 178, 2),
                  ),
                  Text(
                    StringUtils.orders,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 53, 99, 124),
                        fontWeight: FontWeight.w500,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontSize: 15),
                  ),
                ],
              ),
              icon: Column(
                children: [
                  const Icon(
                    Icons.reorder,
                    color: Color.fromARGB(255, 53, 99, 124),
                  ),
                  Text(
                    StringUtils.orders,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 53, 99, 124),
                        // fontWeight: FontWeight.w500,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontSize: 15),
                  ),
                ],
              ),
              label: ''),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 210, 178, 2),
                ),
                Text(
                  StringUtils.favorite,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 53, 99, 124),
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 15),
                ),
              ],
            ),
            icon: Column(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 53, 99, 124),
                ),
                Text(
                  StringUtils.favorite,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 53, 99, 124),
                      // fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                      fontSize: 15),
                ),
              ],
            ),
            label: '',
          ),
        ],
        currentIndex: widget.routeIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.routeIndex = index;
      widget.isFromUpdateOrder = false;
    });
  }
}

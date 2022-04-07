import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/chat/chat_view.dart';
import 'package:kammun_app/views/favoraites/favoraites.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:kammun_app/views/widget/dialog_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  final dynamic notificationValue;

  const HomeView(
      {Key key,
      this.routeIndex,
      this.isFromUpdateOrder = false,
      this.notificationValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken;
  int selectedIndex;
  bool isFromUpdateOrder;
  @override
  void initState() {
    VChatController.instance.bindChatControllers(context: context);

    selectedIndex = widget.routeIndex;
    isFromUpdateOrder = widget.isFromUpdateOrder;
    widget.notificationValue != null
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _showNotificationDialog(ctx: context))
        : Tools.logToConsole('');

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initializeNotification(ctx: context));
    super.initState();
  }

  _initializeNotification({BuildContext ctx}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (message.data['route_name'] != null)
        Navigator.pushNamed(context, message.data['route_name']);

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
    if (LoadingScreenServices.userOriginal.data.firebaseToken !=
        firebaseToken) {
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
          title: Text(
            title,
            style: TextStyle(
              fontFamily: StringUtils.fontFamilyHKGrotesk,
            ),
          ),
          content: Text(
            body,
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
      const StoreView(),
      CartView(
        isFromUpdateOrder: isFromUpdateOrder,
      ),
      const OrdersView(),
      const Favoraites(),
      const ChatView()
    ];
    return Scaffold(
      body: _tabs[selectedIndex],
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
                Icon(
                  Icons.store,
                  color: ColorUtils.kmColors,
                ),
                Text(
                  StringUtils.store,
                  style: homeActiveIconStyle,
                ),
              ],
            ),
            icon: Column(
              children: [
                Icon(
                  Icons.store,
                  color: ColorUtils.primaryColor,
                ),
                Text(
                  StringUtils.store,
                  style: homeIconStyle,
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: ColorUtils.kmColors,
                ),
                Text(
                  StringUtils.cart,
                  style: homeActiveIconStyle,
                ),
              ],
            ),
            icon: Column(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: ColorUtils.primaryColor,
                ),
                Text(
                  StringUtils.cart,
                  style: homeIconStyle,
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Icon(
                  Icons.reorder,
                  color: ColorUtils.kmColors,
                ),
                Text(
                  StringUtils.orders,
                  style: homeActiveIconStyle,
                ),
              ],
            ),
            icon: Column(
              children: [
                Icon(
                  Icons.reorder,
                  color: ColorUtils.primaryColor,
                ),
                Text(
                  StringUtils.orders,
                  style: homeIconStyle,
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: ColorUtils.kmColors,
                ),
                Text(
                  StringUtils.favorite,
                  style: homeActiveIconStyle,
                ),
              ],
            ),
            icon: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: ColorUtils.primaryColor,
                ),
                Text(
                  StringUtils.favorite,
                  style: homeIconStyle,
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Icon(
                  Icons.chat_rounded,
                  color: ColorUtils.kmColors,
                ),
                Text(
                  'المحادثات',
                  style: homeActiveIconStyle,
                ),
              ],
            ),
            icon: Column(
              children: [
                Icon(
                  Icons.chat_rounded,
                  color: ColorUtils.primaryColor,
                ),
                Text(
                  'المحادثات',
                  style: homeIconStyle,
                ),
              ],
            ),
            label: '',
          )
        ],
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isFromUpdateOrder = false;
    });
  }
}

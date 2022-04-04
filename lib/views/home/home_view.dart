import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/orders_view_importer.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  final dynamic notificationValue;

  const HomeView({Key key, this.routeIndex, this.isFromUpdateOrder = false, this.notificationValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeViewState(routeIndex, isFromUpdateOrder);
  }
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex;
  bool _isFromUpdateOrder;

  HomeViewState(this._selectedIndex, this._isFromUpdateOrder);
  List<Widget> tabs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken;

  @override
  void initState() {
    widget.notificationValue != null
        ? WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              List<DialogButton> decisionButtons = [
                DialogButton(
                  text: StringUtils.close,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ];
              showMyDialog(
                  title: widget.notificationValue['title'],
                  text: widget.notificationValue['body'],
                  dialogButtons: decisionButtons,
                  context: context);
            },
          )
        : Tools.logToConsole('');

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeNotification(ctx: context));
    tabs = [];
    tabs.add(const StoreView());
    tabs.add(CartView(
      isFromUpdateOrder: _isFromUpdateOrder,
    ));
    const view = OrdersView();
    if ((Services.isOperationManager())) {
      tabs.add(view);
    }

    if (Services.isShopper() || Services.isSupplierManager()) {
      tabs.add(
        const AssignedOrdersView(),
      );
    }
    super.initState();
  }

  _initializeNotification({BuildContext ctx}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (message.data['route_name'] != null) Navigator.pushNamed(context, message.data['route_name']);

      List<DialogButton> decisionButtons = [
        DialogButton(
          text: StringUtils.close,
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ];
      showMyDialog(
          title: notification.title, text: notification.body, dialogButtons: decisionButtons, context: context);
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
      LoadingScreenServices().updateFirebaseTokenService(firebaseToken);
    } else {
      firebaseToken = prefs.get("firebase_token");
    }
  }

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];

    bottomList.add(BottomNavigationBarItem(
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
                fontFamily: StringUtils.fontFamilyHKGrotesk,
                fontSize: 15),
          ),
        ],
      ),
      label: '',
    ));
    bottomList.add(BottomNavigationBarItem(
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
    ));

    if (Services.isOperationManager()) {
      bottomList.add(BottomNavigationBarItem(
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
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontSize: 15),
            ),
          ],
        ),
        label: '',
      ));
    }

    if (Services.isShopper() || Services.isSupplierManager()) {
      bottomList.add(BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            const Icon(
              Icons.playlist_add_check_outlined,
              color: Color.fromARGB(255, 210, 178, 2),
            ),
            Text(
              StringUtils.myOrders,
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
              Icons.playlist_add_check_outlined,
              color: Color.fromARGB(255, 53, 99, 124),
            ),
            Text(
              StringUtils.myOrders,
              style: TextStyle(
                  color: const Color.fromARGB(255, 53, 99, 124),
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontSize: 15),
            ),
          ],
        ),
        label: '',
      ));
    }
    return BottomNavigationBar(
      selectedFontSize: 0,
      unselectedFontSize: 0,
      backgroundColor: Colors.white,
      items: bottomList,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.white,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: tabs[_selectedIndex], bottomNavigationBar: _bottomNavBar(context: context));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isFromUpdateOrder = false;
    });
  }
}

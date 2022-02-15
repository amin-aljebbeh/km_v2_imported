import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/orders_view_importer.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  dynamic notificationValue;

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
    super.initState();
  }

  _initializeNotification({BuildContext ctx}) {
// Here you can write your code
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['notification'];

        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);

        List<DialogButton> decisionButtons = [
          DialogButton(
            text: StringUtils.close,
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ];
        showMyDialog(
            title: notification['title'],
            text: notification['body'],
            dialogButtons: decisionButtons,
            context: context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['data'];
        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);

        List<DialogButton> decisionButtons = [
          DialogButton(
            text: StringUtils.close,
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ];
        showMyDialog(
            title: notification['title'],
            text: notification['body'],
            dialogButtons: decisionButtons,
            context: context);

        widget.notificationValue = notification;
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];

        if (message['data']['route_name'] != null) Navigator.pushNamed(context, message['data']['route_name']);

        List<DialogButton> decisionButtons = [
          DialogButton(
            text: StringUtils.close,
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ];
        showMyDialog(
            title: notification['title'],
            text: notification['body'],
            dialogButtons: decisionButtons,
            context: context);
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
      LoadingScreenServices().updateFirebaseToken(firebaseToken);
    } else {
      firebaseToken = prefs.get("firebase_token");
    }
  }

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];

    bottomList.add(
      BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.store,
          color: Color.fromARGB(255, 210, 178, 2),
        ),
        icon: Icon(Icons.store, color: Color.fromARGB(255, 53, 99, 124)),
        // ignore: deprecated_member_use
        title: Text(
          StringUtils.store,
          style: naveBarStyle,
        ),
      ),
    );
    bottomList.add(
      BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.shopping_cart,
          color: Color.fromARGB(255, 210, 178, 2),
        ),
        icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 53, 99, 124)),
        // ignore: deprecated_member_use
        title: Text(
          StringUtils.cart,
          style: naveBarStyle,
        ),
      ),
    );

    if (Services.isOperationManager()) {
      bottomList.add(
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.reorder,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(
            Icons.reorder,
            color: Color.fromARGB(255, 53, 99, 124),
          ),
          // ignore: deprecated_member_use
          title: Text(
            StringUtils.allOrders,
            style: naveBarStyle,
          ),
        ),
      );
    }

    if (Services.isDelivery() || Services.isShopper() || Services.isSupplierManager()) {
      bottomList.add(
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.playlist_add_check_outlined,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(
            Icons.playlist_add_check_outlined,
            color: Color.fromARGB(255, 53, 99, 124),
          ),
          // ignore: deprecated_member_use
          title: Text(
            StringUtils.myOrders,
            style: naveBarStyle,
          ),
        ),
      );
    }
    return BottomNavigationBar(
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
    List<Widget> _tabs = [];
    _tabs.add(StoreView());
    _tabs.add(CartView(
      isFromUpdateOrder: _isFromUpdateOrder,
    ));
    if ((Services.isOperationManager())) {
      _tabs.add(
        OrdersView(),
      );
    }

    if (Services.isDelivery() || Services.isShopper() || Services.isSupplierManager()) {
      _tabs.add(
        AssignedOrdersView(),
      );
    }

    return Scaffold(body: _tabs[_selectedIndex], bottomNavigationBar: _bottomNavBar(context: context));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isFromUpdateOrder = false;
    });
  }
}

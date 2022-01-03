import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/assigned_orders_view.dart';
import 'package:kammun_app/views/orders/not_assigned_orders_view.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import '../../utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
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
              // _showNotificationDialog(ctx: context);
            },
          )
        : Tools.logToConsole('do no thing');

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initializeNotification(ctx: context));
    super.initState();
  }

  _initializeNotification({BuildContext ctx}) {
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
        // _showDialog(notification['title'], notification['body']);

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
        // _showDialog(notification['title'], notification['body']);

        widget.notificationValue = notification;
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];
        Tools.logToConsole("onResume: $message");
        // Navigator.push(
        //     context, new MaterialPageRoute(builder: (context) => HomeView(2)));

        if (message['data']['route_name'] != null)
          Navigator.pushNamed(context, message['data']['route_name']);

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
        // _showDialog(notification['title'], notification['body']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    getToken();
    Tools.logToConsole("====== End initializing Firebase ======");
  }

  Future getToken() async {
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

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];

    bottomList.add(
      BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.store,
          // color: Theme.of(context).primaryColor,
          color: Color.fromARGB(255, 210, 178, 2),
        ),
        icon: Icon(Icons.store, color: Color.fromARGB(255, 53, 99, 124)),
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
          // color: Theme.of(context).primaryColor,
          color: Color.fromARGB(255, 210, 178, 2),
        ),
        icon:
            Icon(Icons.shopping_cart, color: Color.fromARGB(255, 53, 99, 124)),
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
              //color: Theme.of(context).primaryColor,
              color: Color.fromARGB(255, 210, 178, 2),
            ),
            icon: Icon(
              Icons.reorder,
              color: Color.fromARGB(255, 53, 99, 124),
            ),
            title: Text(
              StringUtils.allOrders,
              style: naveBarStyle,
            )),
      );
    }

    if (Services.isDelivery() ||
        Services.isShopper() ||
        Services.isSupplierManager()) {
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
          title: Text(
            StringUtils.myOrders,
            style: naveBarStyle,
          ),
        ),
      );
      bottomList.add(
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.reorder,
            //color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(
            Icons.reorder,
            color: Color.fromARGB(255, 53, 99, 124),
          ),
          title: Text(
            StringUtils.orders,
            style: naveBarStyle,
          ),
        ),
      );
    }

    return BottomNavigationBar(
      // backgroundColor: Color.fromARGB(255, 53, 99, 124),
      //backgroundColor: Color.fromARGB(255, 57, 107, 137),
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

    if (Services.isDelivery() || Services.isShopper()) {
      _tabs.add(
        AssignedOrdersView(),
      );
      _tabs.add(
        NotAssignedOrdersView(),
      );
    }

    return Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: _bottomNavBar(context: context));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isFromUpdateOrder = false;
    });
  }
}

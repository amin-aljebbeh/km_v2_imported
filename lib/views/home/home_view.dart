import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/string_utils.dart';
import 'package:kammun_app/utils/string_utils.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/inventory/inventory.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/assigned_orders_view.dart';
import 'package:kammun_app/views/orders/not_assigned_orders_view.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/prices_changes/prices.dart';
import 'package:kammun_app/views/store/store_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import '../../utils/Styles.dart';

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
                  text: 'إغلاق',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ];
              showMyDialog(
                  widget.notificationValue['title'],
                  widget.notificationValue['body'],
                  decisionButtons,
                  null,
                  context);
              // _showNotificationDialog(ctx: context);
            },
          )
        : {};

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
            text: 'إغلاق',
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ];
        showMyDialog(notification['title'], notification['body'],
            decisionButtons, null, context);
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
            text: 'إغلاق',
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ];
        showMyDialog(notification['title'], notification['body'],
            decisionButtons, null, context);
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
            text: 'إغلاق',
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ];
        showMyDialog(notification['title'], notification['body'],
            decisionButtons, null, context);
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

  Future<List<String>> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roles = [];
    try {
      roles.add(prefs.getString(UtilsImporter().stringUtils.superAdminRole));
    } catch (e) {}
    try {
      roles.add(prefs.getString(UtilsImporter().stringUtils.adminRole));
    } catch (e) {}
    try {
      roles.add(prefs.getString(UtilsImporter().stringUtils.deliveryRole));
    } catch (e) {}
    try {
      roles.add(prefs.getString(UtilsImporter().stringUtils.shopperRole));
    } catch (e) {}
    return roles;
  }

  Widget _bottomNavBar({BuildContext context}) {
    Services.roles = getRole as List<String>;
    // return CupertinoNavigationBar(
    //   heroTag: ,
    // );
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
            UtilsImporter().stringUtils.store,
            style: naveBarStyle,
          )),
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
          UtilsImporter().stringUtils.cart,
          style: naveBarStyle,
        ),
      ),
    );
    if (Services.roles.contains(UtilsImporter().stringUtils.superAdminRole))
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
              'كل الطلبات',
              style: naveBarStyle,
            )),
      );
    if (Services.roles.contains(UtilsImporter().stringUtils.shopperRole) ||
        Services.roles.contains(UtilsImporter().stringUtils.deliveryRole)) {
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
              UtilsImporter().stringUtils.orders,
              style: naveBarStyle,
            )),
      );
      bottomList.add(
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.playlist_add_check_outlined,
            // color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(
            Icons.playlist_add_check_outlined,
            color: Color.fromARGB(255, 53, 99, 124),
          ),
          title: Text(
            'طلباتي',
            style: naveBarStyle,
          ),
        ),
      );
    }

    // if (LoadingScreenServices.viewOrderPermission) {
    //   bottomList.add(
    //     BottomNavigationBarItem(
    //         activeIcon: Icon(
    //           Icons.reorder,
    //           //color: Theme.of(context).primaryColor,
    //           color: Color.fromARGB(255, 210, 178, 2),
    //         ),
    //         icon: Icon(
    //           Icons.reorder,
    //           color: Color.fromARGB(255, 53, 99, 124),
    //         ),
    //         title: Text(
    //           UtilsImporter().stringUtils.orders,
    //           style: naveBarStyle,
    //         )),
    //   );
    //   bottomList.add(
    //     BottomNavigationBarItem(
    //       activeIcon: Icon(
    //         Icons.playlist_add_check_outlined,
    //         // color: Theme.of(context).primaryColor,
    //         color: Color.fromARGB(255, 210, 178, 2),
    //       ),
    //       icon: Icon(
    //         Icons.playlist_add_check_outlined,
    //         color: Color.fromARGB(255, 53, 99, 124),
    //       ),
    //       title: Text(
    //         'طلباتي',
    //         style: naveBarStyle,
    //       ),
    //     ),
    //   );
    // }
    // bottomList.add(
    //   BottomNavigationBarItem(
    //       activeIcon: Icon(
    //         Icons.category,
    //         // color: Theme.of(context).primaryColor,
    //         color: Color.fromARGB(255, 210, 178, 2),
    //       ),
    //       icon: Icon(Icons.category, color: Color.fromARGB(255, 53, 99, 124)),
    //       title: Text(
    //         "جرد منتجات",
    //         style: naveBarStyle,
    //       )),
    // );
    // if (LoadingScreenServices.productsOperationPermission) {
    //   bottomList.add(
    //     BottomNavigationBarItem(
    //         activeIcon: Icon(
    //           Icons.category,
    //           // color: Theme.of(context).primaryColor,
    //           color: Color.fromARGB(255, 210, 178, 2),
    //         ),
    //         icon: Icon(Icons.category, color: Color.fromARGB(255, 53, 99, 124)),
    //         title: Text(
    //           "جرد منتجات",
    //           style: naveBarStyle,
    //         )),
    //   );
    // }
    // if (LoadingScreenServices.isSuperAdmin) {
    //   bottomList.add(
    //     BottomNavigationBarItem(
    //       activeIcon: Icon(
    //         Icons.money_off_csred_outlined,
    //         // color: Theme.of(context).primaryColor,
    //         color: Color.fromARGB(255, 210, 178, 2),
    //       ),
    //       icon: Icon(
    //         Icons.money_off_csred_outlined,
    //         color: Color.fromARGB(255, 53, 99, 124),
    //       ),
    //       title: Text(
    //         "الأسعار",
    //         style: naveBarStyle,
    //       ),
    //     ),
    //   );
    // }

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
    if (Services.roles.contains(UtilsImporter().stringUtils.superAdminRole))
      _tabs.add(
        new OrdersView(),
      );
    if (Services.roles.contains(UtilsImporter().stringUtils.shopperRole) ||
        Services.roles.contains(UtilsImporter().stringUtils.deliveryRole)) {
      _tabs.add(
        NotAssignedOrdersView(),
      );
      _tabs.add(
        AssignedOrdersView(),
      );
    }

    //TODO: distinguishing the roles
    // if (LoadingScreenServices.viewOrderPermission) {
    //   _tabs.add(
    //     new OrdersView(
    //       orderType: UtilsImporter().stringUtils.notAssignedOrder,
    //       role: UtilsImporter().stringUtils.shopperRole,
    //     ),
    //   );
    //   _tabs.add(
    //     new OrdersView(
    //       orderType: UtilsImporter().stringUtils.myOrder,
    //       role: UtilsImporter().stringUtils.shopperRole,
    //     ),
    //   );
    // }
    // _tabs.add(Inventory());
    // if (LoadingScreenServices.productsOperationPermission) {
    //   _tabs.add(Inventory());
    // }

    // if (LoadingScreenServices.isSuperAdmin) {
    //   _tabs.add(Prices());
    // }

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

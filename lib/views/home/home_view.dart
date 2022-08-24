import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/orders/orders_view_importer.dart';
import 'package:kammun_app/views/store/store_view.dart';

import '../../core/core_importer.dart';
import 'bottom_bar_item.dart';

class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  final dynamic notificationValue;

  const HomeView({Key key, this.routeIndex, this.isFromUpdateOrder = false, this.notificationValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int selectedIndex;
  bool isFromUpdateOrder;

  List<Widget> tabs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken;

  @override
  void initState() {
    selectedIndex = widget.routeIndex;
    isFromUpdateOrder = widget.isFromUpdateOrder;

    widget.notificationValue != null
        ? WidgetsBinding.instance.addPostFrameCallback((_) => showMyDialog(
            context: context,
            title: widget.notificationValue['title'],
            text: widget.notificationValue['body'],
            dialogButtons: [const CloseButton()]))
        : {};

    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeNotification(ctx: context));
    tabs = [];
    tabs.add(const StoreView());
    tabs.add(CartView(isFromUpdateOrder: isFromUpdateOrder));
    if ((Services.isOperationManager())) tabs.add(const OrdersView());

    if (Services.isShopper() || Services.isSupplierManager()) tabs.add(const AssignedOrdersView());

    super.initState();
  }

  _initializeNotification({BuildContext ctx}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (message.data['route_name'] != null) Navigator.pushNamed(context, message.data['route_name']);
      showMyDialog(
          context: context, title: notification.title, text: notification.body, dialogButtons: [const CloseWidget()]);
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    getToken();
  }

  Future getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get('firebase_token') == null) {
        firebaseToken = await _firebaseMessaging.getToken();
        prefs.setString('firebase_token', firebaseToken);
        LoadingScreenServices().updateFirebaseTokenService(firebaseToken);
      } else {
        firebaseToken = prefs.get('firebase_token');
      }
    } catch (e) {/**/}
  }

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];
    bottomList.add(BottomBarItem.build(text: StringUtils.store, icon: Icons.store));
    bottomList.add(BottomBarItem.build(text: StringUtils.cart, icon: Icons.shopping_cart));
    if (Services.isOperationManager()) {
      bottomList.add(BottomBarItem.build(text: StringUtils.orders, icon: Icons.reorder));
    }
    if (Services.isShopper() || Services.isSupplierManager()) {
      bottomList.add(BottomBarItem.build(text: StringUtils.myOrders, icon: Icons.playlist_add_check_outlined));
    }

    return BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        backgroundColor: Colors.white,
        items: bottomList,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        onTap: _onItemTapped);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: tabs[selectedIndex], bottomNavigationBar: _bottomNavBar(context: context));

  void _onItemTapped(int index) => setState(() {
        selectedIndex = index;
        isFromUpdateOrder = false;
      });
}

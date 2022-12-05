import 'package:kammun_app/features/orders/orders_view_importer.dart';

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

  @override
  void initState() {
    selectedIndex = widget.routeIndex;
    isFromUpdateOrder = widget.isFromUpdateOrder;

    widget.notificationValue != null
        ? WidgetsBinding.instance.addPostFrameCallback((_) => showMyDialog(
            context: context,
            title: widget.notificationValue['title'],
            text: widget.notificationValue['body'],
            dialogButtons: [const CloseWidget()]))
        : {};

    tabs = [];
    tabs.add(const StoreView());
    tabs.add(CartView(isFromUpdateOrder: isFromUpdateOrder));
    if ((Services.isOperationManager())) tabs.add(const OrdersView());

    if (Services.isShopper() || Services.isSupplierManager()) tabs.add(const AssignedOrdersView());

    super.initState();
  }

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];
    bottomList.add(BottomBarItem.build(text: store, icon: Icons.store));
    bottomList.add(BottomBarItem.build(text: cart, icon: Icons.shopping_cart));
    if (Services.isOperationManager()) {
      bottomList.add(BottomBarItem.build(text: orders, icon: Icons.reorder));
    }
    if (Services.isShopper() || Services.isSupplierManager()) {
      bottomList.add(BottomBarItem.build(text: myOrders, icon: Icons.playlist_add_check_outlined));
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

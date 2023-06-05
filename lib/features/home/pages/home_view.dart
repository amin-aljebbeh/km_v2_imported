import '../../../core/core_importer.dart';
import '../../orders/presentation/pages/orders_page.dart';
import '../../orders/presentation/redux/orders_action.dart';
import '../widgets/bottom_bar_item.dart';

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

  List<Widget> tabs = [];

  @override
  void initState() {
    selectedIndex = widget.routeIndex;
    isFromUpdateOrder = widget.isFromUpdateOrder;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.notificationValue != null) {
        showMyDialog(
            context: context,
            title: widget.notificationValue['title'],
            text: widget.notificationValue['body'],
            dialogButtons: [const CloseWidget()]);
      }
    });

    super.initState();
  }

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];
    bottomList.add(BottomBarItem.build(text: store, icon: Icons.store));
    bottomList.add(BottomBarItem.build(text: cart, icon: Icons.shopping_cart));
    if (Services.hasRole(context, operationManagerRole) ||
        Services.hasRole(context, shopperRole) ||
        Services.hasRole(context, supplierRole)) {
      bottomList.add(BottomBarItem.build(text: orders, icon: Icons.reorder));
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
  Widget build(BuildContext context) {
    tabs.add(const StoreView());
    tabs.add(CartView(isFromUpdateOrder: isFromUpdateOrder));
    if (Services.hasRole(context, operationManagerRole) ||
        Services.hasRole(context, shopperRole) ||
        Services.hasRole(context, supplierRole)) tabs.add(const OrdersPage());

    return Scaffold(body: tabs[selectedIndex], bottomNavigationBar: _bottomNavBar(context: context));
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      if (StoreProvider.of<AppState>(context).state.ordersState.orders.isEmpty) {
        StoreProvider.of<AppState>(context).dispatch(GetOrdersAction(context: context));
      }
    }
    setState(() {
      selectedIndex = index;
      isFromUpdateOrder = false;
    });
  }
}

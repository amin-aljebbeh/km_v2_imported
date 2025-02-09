import 'package:kammun_app/features/cart/presentation/pages/cart_page.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../orders/presentation/redux/orders_action.dart';
import '../redux/home_action.dart';
import '../widgets/bottom_bar_item.dart';

class HomePage extends StatefulWidget {
  final dynamic notificationValue;
  static const String routeName = '/HomePage';

  const HomePage({Key key, this.notificationValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Widget> tabs = [];
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    tabs.add(StoreView());
    tabs.add(const CartPage());
    if (Services.hasRole(context, operationManagerRole) ||
        Services.hasRole(context, shopperRole) ||
        Services.hasRole(context, supplierRole)) tabs.add(const OrdersPage());
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
            body: tabs[state.homeState.pageIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 0,
              unselectedFontSize: 0,
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomBarItem.build(text: storeString, icon: Icons.store),
                BottomBarItem.build(text: cart, icon: Icons.shopping_cart),
                if (Services.hasRole(context, operationManagerRole) ||
                    Services.hasRole(context, shopperRole) ||
                    Services.hasRole(context, supplierRole))
                  BottomBarItem.build(text: orders, icon: Icons.reorder)
              ],
              currentIndex: state.homeState.pageIndex,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.white,
              onTap: (index) {
                if (index == 2) {
                  if (StoreProvider.of<AppState>(context).state.ordersState.orders.isEmpty) {
                    StoreProvider.of<AppState>(context).dispatch(GetOrdersAction(context: context));
                  }
                }
                StoreProvider.of<AppState>(context).dispatch(SetPageIndex(index: index));
              },
            ));
      },
    );
  }
}

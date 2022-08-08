import 'package:flutter/material.dart';
import '../../products/redux/products_action.dart';
import '../../../core/core_importer.dart';
import '../../cart/view/cart_view.dart';
import '../../orders/view/orders_view.dart';
import '../../products/view/products_view.dart';
import '../redux/home_page_action.dart';
import '../services/home_page_service.dart';

class HomeView extends StatefulWidget {
  final int index;

  const HomeView({Key key, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  int index;

  @override
  void initState() {
    super.initState();
    updateFirebaseToken();
    index = widget.index;
  }

  updateFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firebaseToken = prefs.getString('firebase_token');
    if (StoreProvider.of<AppState>(navigatorKey.currentContext).state.startupState.startModel != null) {
      String user =
          StoreProvider.of<AppState>(navigatorKey.currentContext).state.startupState.startModel.user.firebaseToken;
      if (user != firebaseToken) {
        HomePageService.updateFirebaseTokenService(firebaseToken);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const StoreView(),
      const CartView(),
      const OrdersView(),
      const ProductsView(productsViewType: ProductsViewTypes.favorite)
    ];
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        int cartCount = state.cartState.cartProducts.length;
        return TemporaryLoading(
          child: Scaffold(
            body: tabs[index],
            bottomNavigationBar: BottomNavigationBar(
              unselectedFontSize: 0,
              selectedFontSize: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomBarItem.build(text: StringUtils.store, icon: Icons.home),
                BottomBarItem.build(text: StringUtils.cart, icon: Icons.shopping_cart, cartCount: cartCount),
                BottomBarItem.build(text: StringUtils.orders, icon: NewIcons.iceCube),
                BottomBarItem.build(text: StringUtils.favorite, icon: Icons.favorite),
              ],
              currentIndex: index,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.white,
              onTap: (newIndex) {
                StoreProvider.of<AppState>(context).dispatch(NoError());
                if (!state.loadingState.isLoading && index != newIndex) {
                  if (newIndex != 3) {
                    StoreProvider.of<AppState>(context)
                        .dispatch(SetType(productsViewTypes: ProductsViewTypes.category));
                  }
                  if ([2, 3].contains(newIndex)) {
                    StoreProvider.of<AppState>(context).dispatch(FirstPaginationPage());
                    StoreProvider.of<AppState>(context).dispatch(StartLoading());
                  }
                  setState(() => index = newIndex);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

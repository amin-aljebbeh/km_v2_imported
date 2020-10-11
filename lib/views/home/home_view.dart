import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/favoraites/favoraites.dart';
import 'package:kammun_app/views/orders/orders_view.dart';
import 'package:kammun_app/views/store/store_view.dart';

class HomeView extends StatefulWidget {
  final int routeIndex;
  final bool isFromUpdateOrder;
  final dynamic notificationValue;

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

  @override
  void initState() {
    widget.notificationValue != null
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _showNotificationDialog(ctx: context))
        : {};
    super.initState();
  }

  _showNotificationDialog({BuildContext ctx}) {
    String title = widget.notificationValue["title"];
    String body = widget.notificationValue["body"];
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          content: new Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
              onPressed: () {
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
      StoreView(),
      CartView(
        isFromUpdateOrder: _isFromUpdateOrder,
      ),
      OrdersView(),
      Favoraites(),
    ];
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Color.fromARGB(255, 53, 99, 124),
        //backgroundColor: Color.fromARGB(255, 57, 107, 137),
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.store,
                // color: Theme.of(context).primaryColor,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(Icons.store, color: Color.fromARGB(255, 53, 99, 124)),
              title: Text(
                UtilsImporter().stringUtils.store,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    fontSize: 15),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.shopping_cart,
                // color: Theme.of(context).primaryColor,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(Icons.shopping_cart,
                  color: Color.fromARGB(255, 53, 99, 124)),
              title: Text(
                UtilsImporter().stringUtils.cart,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    fontSize: 15),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.reorder,
                //color: Theme.of(context).primaryColor,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon:
                  Icon(Icons.reorder, color: Color.fromARGB(255, 53, 99, 124)),
              title: Text(
                UtilsImporter().stringUtils.orders,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    fontSize: 15),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.favorite,
                //   color: Theme.of(context).primaryColor,
                color: Color.fromARGB(255, 210, 178, 2),
              ),
              icon: Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 53, 99, 124),
              ),
              title: Text(
                UtilsImporter().stringUtils.profile,
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 99, 124),
                    fontWeight: FontWeight.w500,
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                    fontSize: 15),
              )),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isFromUpdateOrder = false;
    });
  }
}

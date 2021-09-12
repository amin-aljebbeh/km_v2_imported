import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cache_image/cache_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/colors_utils.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

import 'full_screen_image.dart';
import 'order_accounting.dart';
import 'order_details_view_main.dart';

// ignore: must_be_immutable
class OrderDetailView extends StatefulWidget {
  List<OrderProducts> ordersAry;
  int subTotal;
  String total;
  String delivery_price;
  int orderIndex;
  int orderId;
  String addressName;

  OrderDetailView(
      {this.ordersAry,
      this.subTotal,
      this.total,
      this.delivery_price,
      this.orderId,
      this.addressName,
      this.orderIndex});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewState();
  }
}

class OrderDetailViewState extends State<OrderDetailView> {
  ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;
  List<Widget> _tabs = [];
  @override
  void initState() {
    _tabs.addAll([
      OrderDetailViewMain(
        ordersAry: widget.ordersAry,
        orderIndex: widget.orderIndex,
        addressName: widget.addressName,
        orderId: widget.orderId,
        subTotal: widget.subTotal,
        total: widget.total,
        delivery_price: widget.delivery_price,
      ),
      OrderAccounting(
        ordersAry: widget.ordersAry,
      ),
    ]);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buttomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> buttomList = [];

    buttomList.add(
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.home,
            // color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(Icons.account_balance,
              color: Color.fromARGB(255, 53, 99, 124)),
          title: Text(
            "الرئيسية",
            style: TextStyle(
                color: Color.fromARGB(255, 53, 99, 124),
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                fontSize: 15),
          )),
    );
    buttomList.add(
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.account_balance,
            // color: Theme.of(context).primaryColor,
            color: Color.fromARGB(255, 210, 178, 2),
          ),
          icon: Icon(Icons.account_balance,
              color: Color.fromARGB(255, 53, 99, 124)),
          title: Text(
            "الحسابات",
            style: TextStyle(
                color: Color.fromARGB(255, 53, 99, 124),
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                fontSize: 15),
          )),
    );

    return BottomNavigationBar(
      // backgroundColor: Color.fromARGB(255, 53, 99, 124),
      //backgroundColor: Color.fromARGB(255, 57, 107, 137),
      backgroundColor: Colors.white,
      items: buttomList,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.white,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: _buttomNavBar(context: context));
    ;
  }
}

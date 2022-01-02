import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/common_utils.dart';
import '../../utils/Styles.dart';
import 'order_accounting.dart';
import 'order_details_view_main.dart';

// ignore: must_be_immutable
class OrderDetailView extends StatefulWidget {
  List<OrderProducts> ordersAry;
  int subTotal;
  String total;
  String deliveryPrice;
  int orderIndex;
  int orderId;
  String addressName;
  OrdersOriginalData orderData;
  final OrderType orderType;

  OrderDetailView({
    this.ordersAry,
    this.subTotal,
    this.total,
    this.deliveryPrice,
    this.orderId,
    this.addressName,
    this.orderIndex,
    this.orderData,
    @required this.orderType,
  });

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewState();
  }
}

class OrderDetailViewState extends State<OrderDetailView> {
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
        deliveryPrice: widget.deliveryPrice,
        order: widget.orderData,
        orderType: widget.orderType,
      ),
      OrderAccounting(
        orderData: widget.orderData,
        ordersAry: widget.ordersAry,
        orderId: widget.orderId,
      ),
    ]);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomNavBar({BuildContext context}) {
    List<BottomNavigationBarItem> bottomList = [];

    bottomList.add(
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
          style: naveBarStyle,
        ),
      ),
    );
    bottomList.add(
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
          style: naveBarStyle,
        ),
      ),
    );

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
    return Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: _bottomNavBar(context: context));
  }
}

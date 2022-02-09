import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/common_utils.dart';
import 'package:kammun_app/views/order_details/order_details_tab_view.dart';
import '../../utils/Styles.dart';
import 'order_accounting.dart';

// ignore: must_be_immutable
class OrderDetailView extends StatefulWidget {
  int subTotal;
  String total;
  OrdersOriginalData orderData;
  final OrderTypes orderType;

  OrderDetailView({
    this.subTotal,
    this.total,
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
    _tabs.add(
      OrderDetailsTabView(
        subTotal: widget.subTotal,
        total: widget.total.split('.')[0],
        orderData: widget.orderData,
        orderType: widget.orderType,
      ),
    );
    _tabs.add(
      OrderAccounting(
        orderData: widget.orderData,
      ),
    );
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
          color: Color.fromARGB(255, 210, 178, 2),
        ),
        icon: Icon(
          Icons.account_balance,
          color: Color.fromARGB(255, 53, 99, 124),
        ),
        // ignore: deprecated_member_use
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
          color: Color.fromARGB(255, 210, 178, 2),
        ),
        icon: Icon(
          Icons.account_balance,
          color: Color.fromARGB(255, 53, 99, 124),
        ),
        // ignore: deprecated_member_use
        title: Text(
          "الحسابات",
          style: naveBarStyle,
        ),
      ),
    );

    return BottomNavigationBar(
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
      bottomNavigationBar: _bottomNavBar(context: context),
    );
  }
}

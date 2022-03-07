import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/order_details/order_accounting.dart';
import 'package:kammun_app/views/order_details/order_deleted_products.dart';

import '../../Services.dart';
import 'order_details_view_main.dart';

// ignore: must_be_immutable
class OrderDetailsTabView extends StatefulWidget {
  int subTotal;
  String total;
  OrdersOriginalData orderData;
  final OrderTypes orderType;
  double remaining;
  double totalDiscount;

  OrderDetailsTabView(
      {Key key, this.orderType, this.orderData, this.subTotal, this.total, this.remaining, this.totalDiscount})
      : super(key: key);

  @override
  _OrderDetailsTabViewState createState() => _OrderDetailsTabViewState();
}

class _OrderDetailsTabViewState extends State<OrderDetailsTabView> with SingleTickerProviderStateMixin {
  bool deletedProducts;
  List<Widget> tabList = [];
  List<Widget> screenList = [];
  TabController controller;

  tabBarList() {
    tabList.add(
      Tab(
        child: Center(
          child: Text(
            'المنتجات',
            style: naveBarStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
    screenList.add(
      OrderDetailViewMain(
        subTotal: widget.subTotal,
        order: widget.orderData,
        orderType: widget.orderType,
        remaining: widget.remaining,
        totalDiscount: widget.totalDiscount,
      ),
    );
    if (!Services.isSupplierManager()) {
      if (deletedProducts) {
        tabList.add(
          Center(
            child: Tab(
              child: Center(
                child: Text(
                  ' المحذوفة',
                  style: naveBarStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        );
        screenList.add(
          OrderDeletedProducts(
            subTotal: widget.subTotal,
            total: widget.total.split('.')[0],
            order: widget.orderData,
            orderType: widget.orderType,
          ),
        );
      }

      tabList.add(
        Tab(
          child: Center(
            child: Text(
              'الحسابات',
              style: naveBarStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
      screenList.add(
        OrderAccounting(
          orderData: widget.orderData,
          onDelete: () {
            controller.animateTo(0);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      deletedProducts = Services.isAdmin() &&
          widget.orderData.products.where((product) => product.pivot.deletedAt != 'null').toList().length > 0;
      tabBarList();
    });
    controller = TabController(vsync: this, length: tabList.length);

    super.initState();
  }

  bool isLoading = false;
  bool errorAlert = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: screenList.length,
      child: Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: ColorUtils.primaryColor,
            child: new SafeArea(
              child: new TabBar(
                controller: controller,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: tabList,
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: screenList,
        ),
      ),
    );
  }
}

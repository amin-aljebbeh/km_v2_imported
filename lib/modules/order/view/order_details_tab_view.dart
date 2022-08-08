import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../models/get_order_model.dart';

class OrderDetailsTabView extends StatefulWidget {
  final GetOrderResponse orderData;

  const OrderDetailsTabView({Key key, this.orderData}) : super(key: key);

  @override
  _OrderDetailsTabViewState createState() => _OrderDetailsTabViewState();
}

class _OrderDetailsTabViewState extends State<OrderDetailsTabView> with SingleTickerProviderStateMixin {
  List<Widget> tabList = [];
  List<Widget> screenList = [];
  TabController controller;

  tabBarList() {
    tabList.add(Tab(
      child: Center(child: Text('المنتجات', style: tabStyle, textAlign: TextAlign.center)),
    ));
    screenList.add(OrderDetailView(
        products: widget.orderData.order.products.where((product) => product.pivot.deletedAt == 'null').toList()));
    if (widget.orderData.order.products.where((product) => product.pivot.deletedAt != 'null').toList().isNotEmpty) {
      tabList.add(Center(
          child: Tab(
              child: Center(child: AutoSizeText('المنتجات المحذوفة', style: tabStyle, textAlign: TextAlign.center)))));
      screenList.add(OrderDetailView(
          products: widget.orderData.order.products.where((product) => product.pivot.deletedAt != 'null').toList()));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StopLoading());
    });
    tabBarList();
    controller = TabController(vsync: this, length: tabList.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: screenList.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight((kToolbarHeight * 2) - 0.5),
          child: Container(
            color: ColorUtils.kmColors,
            child: SafeArea(
              child: Column(
                children: [
                  const NormalAppBar(title: 'معلومات الطلب', pop: true),
                  Container(
                    color: ColorUtils.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.50),
                      child: TabBar(
                          controller: controller,
                          indicatorColor: Colors.white,
                          labelColor: ColorUtils.primaryColor,
                          unselectedLabelColor: ColorUtils.primaryColor,
                          tabs: tabList),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(controller: controller, children: screenList),
      ),
    );
  }
}

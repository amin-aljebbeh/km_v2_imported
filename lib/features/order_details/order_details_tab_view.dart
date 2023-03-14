import 'package:kammun_app/features/order_details/order_accounting.dart';
import 'package:kammun_app/features/order_details/order_deleted_products.dart';

import '../../core/core_importer.dart';
import 'order_details_view_main.dart';

// ignore: must_be_immutable
class OrderDetailsTabView extends StatefulWidget {
  int subTotal;
  OrdersOriginalData orderData;
  final OrderTypes orderType;
  double remaining;
  double totalDiscount;

  OrderDetailsTabView({Key key, this.orderType, this.orderData, this.subTotal, this.remaining, this.totalDiscount})
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
    tabList.add(Tab(child: Center(child: Text('المنتجات', style: tabStyle))));
    screenList.add(OrderDetailViewMain(
        subTotal: widget.subTotal,
        order: widget.orderData,
        orderType: widget.orderType,
        remaining: widget.remaining,
        totalDiscount: widget.totalDiscount));
    if (!Services.isSupplierManager()) {
      if (deletedProducts) {
        tabList.add(Center(child: Tab(child: Center(child: Text(' المحذوفة', style: tabStyle)))));
        screenList.add(OrderDeletedProducts(order: widget.orderData, orderType: widget.orderType));
      }
    }
    tabList.add(Tab(child: Center(child: Text('الحسابات', style: tabStyle))));
    screenList.add(OrderAccounting(orderData: widget.orderData, onDelete: () => controller.animateTo(0)));
  }

  @override
  void initState() {
    deletedProducts = (Services.isAdmin() || Services.isOperationManager()) &&
        widget.orderData.products.where((product) => product.pivot.deletedAt != 'null').toList().isNotEmpty;
    tabBarList();
    controller = TabController(vsync: this, length: tabList.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TemporaryLoading(
      child: DefaultTabController(
        length: screenList.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
                color: primaryColor,
                child: SafeArea(
                    child: TabBar(
                        controller: controller,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        tabs: tabList))),
          ),
          body: TabBarView(
              controller: controller,
              children: screenList,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())),
        ),
      ),
    );
  }
}

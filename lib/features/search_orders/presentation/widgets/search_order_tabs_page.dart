import 'package:kammun_app/features/order_details/presentation/pages/order_accounting.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/order_entity.dart';
import 'search_order_products_page.dart';

class SearchOrderTabsPage extends StatefulWidget {
  final OrderEntity order;
  final bool deleted;

  const SearchOrderTabsPage({Key key, this.order, this.deleted = false}) : super(key: key);

  @override
  _OrderTabsPageState createState() => _OrderTabsPageState();
}

class _OrderTabsPageState extends State<SearchOrderTabsPage> with SingleTickerProviderStateMixin {
  List<Widget> tabList = [];
  List<Widget> screenList = [];
  TabController controller;

  tabBarList() {
    tabList.add(Tab(child: Center(child: Text('المنتجات', style: tabStyle))));
    screenList.add(SearchOrderProductsPage(order: widget.order, deleted: false));
    if (widget.deleted) {
      tabList.add(Center(child: Tab(child: Center(child: Text(' المحذوفة', style: tabStyle)))));
      screenList.add(SearchOrderProductsPage(order: widget.order, deleted: true));
    }
    tabList.add(Tab(child: Center(child: Text('الحسابات', style: tabStyle))));
    screenList.add(OrderAccounting(order: widget.order, onDelete: () => controller.animateTo(0)));
  }

  @override
  void initState() {
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
                    child: Row(
                  children: [
                    /*IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),*/
                    Expanded(
                      child: TabBar(
                          controller: controller,
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          tabs: tabList),
                    ),
                  ],
                ))),
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

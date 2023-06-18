import '../../../../core/core_importer.dart';
import '../redux/excel_inventory_action.dart';
import 'inventory_file_product.dart';
import 'price_file_product.dart';

class ExcelInventoryPage extends StatefulWidget {
  const ExcelInventoryPage({Key key}) : super(key: key);

  @override
  _ExcelInventoryPageState createState() => _ExcelInventoryPageState();
}

class _ExcelInventoryPageState extends State<ExcelInventoryPage> {
  List<Widget> tabList = [];
  List<Widget> screenList = [];

  tabBarList() {
    tabList.add(Tab(child: Center(child: Text('الجرد', style: tabStyle))));
    tabList.add(Tab(child: Center(child: Text('الأسعار', style: tabStyle))));
    screenList.add(const InventoryFileProduct());
    screenList.add(const PriceFileProduct());
  }

  @override
  void initState() {
    tabBarList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return WillPopScope(
            child: DefaultTabController(
              initialIndex: 1,
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                        color: primaryColor,
                        child: SafeArea(
                            child: TabBar(indicatorColor: Colors.white, labelColor: Colors.white, tabs: tabList))),
                  ),
                  title: Text(inventory, style: appBarStyle),
                ),
                body: TabBarView(children: screenList),
              ),
            ),
            onWillPop: () async {
              StoreProvider.of<AppState>(context)
                  .dispatch(InitExcelInventory(subWarehouseId: state.excelInventoryState.subWarehouseId));
              return true;
            });
      },
    );
  }
}

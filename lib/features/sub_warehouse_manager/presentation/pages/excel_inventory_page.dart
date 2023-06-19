import '../../../../core/core_importer.dart';
import '../redux/sub_warehouse_manager_action.dart';
import 'inventory_file_product.dart';
import 'price_file_product.dart';

class ExcelInventoryPage extends StatelessWidget {
  const ExcelInventoryPage({Key key}) : super(key: key);

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
                        child: TabBar(
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          tabs: [
                            Tab(child: Center(child: Text('الجرد', style: tabStyle))),
                            Tab(child: Center(child: Text('الأسعار', style: tabStyle)))
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: Text(inventory, style: appBarStyle),
                ),
                body: const TabBarView(children: [InventoryFileProduct(), PriceFileProduct()]),
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

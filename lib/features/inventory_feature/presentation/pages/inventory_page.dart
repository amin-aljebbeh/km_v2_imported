import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_action.dart';

class InventoryPage extends StatefulWidget {
  static const String routeName = '/InventoryPage';

  const InventoryPage({Key key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int subWarehouseFilter = StaticVariables.subWarehouses.length;
  final List<String> activeList = ['بحاجة تفعيل', 'بحاجة إيقاف تفعيل', 'الجميع'];

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(StartLoading());
      StoreProvider.of<AppState>(context).dispatch(NoError());
      StoreProvider.of<AppState>(context).dispatch(ClearInventory());
      StoreProvider.of<AppState>(context).dispatch(GetInventory());
    });
    controller.addListener(
        () => StoreProvider.of<AppState>(context).dispatch(SetSearchFilter(searchFilter: controller.text)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        var inventoryState = state.inventoryState;
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: InventorySearchTextField(
              onReload: () {
                store.dispatch(StartLoading());
                store.dispatch(NoError());
                store.dispatch(ClearInventory());
                store.dispatch(GetInventory());
              },
              controller: controller,
              context: context),
          body: WillPopScope(
            onWillPop: () async {
              store.dispatch(NoError());
              return true;
            },
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                          value: subWarehouseFilter,
                          items: Services.inventorySubWarehouseNames(),
                          onChanged: (value) {
                            subWarehouseFilter = value;
                            store.dispatch(SetSubWarehouseId(
                                subWarehouseId: value != StaticVariables.subWarehouses.length
                                    ? StaticVariables.subWarehouses[value].id
                                    : -1));
                            store.dispatch(StartLoading());
                            store.dispatch(NoError());
                            store.dispatch(ClearInventory());
                            store.dispatch(GetInventory());
                          },
                        ),
                        DropdownButton(
                          value: inventoryState.isActive,
                          items: Services.dropdownStringList(activeList),
                          onChanged: (value) {
                            store.dispatch(SetIsActive(isActive: value));
                            store.dispatch(StartLoading());
                            store.dispatch(NoError());
                            store.dispatch(ClearInventory());
                            store.dispatch(GetInventory());
                          },
                        ),
                      ],
                    ),
                  ),
                  state.errorState.isError
                      ? Expanded(
                          child: Column(
                            children: [
                              AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'),
                              KammunButton(
                                  onTap: () {
                                    store.dispatch(NoError());
                                    store.dispatch(StartLoading());
                                    store.dispatch(ClearInventory());
                                    store.dispatch(GetInventory());
                                  },
                                  color: primaryColor,
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  text: 'المحاولة من جديد'),
                            ],
                          ),
                        )
                      : inventoryState.products.isEmpty && state.loadingState.loading.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Center(child: Text('لا يوجد منتجات', style: boldStyle)))
                          : Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scrollInfo) {
                                  if (state.loadingState.loading.isEmpty &&
                                      scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                      inventoryState.hasNext) {
                                    store.dispatch(StartLoading());
                                    store.dispatch(NextPage());
                                    store.dispatch(GetInventory());
                                  }
                                  return;
                                },
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: inventoryState.products.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (inventoryState.searchFilter == null ||
                                        inventoryState.searchFilter == '' ||
                                        inventoryState.products[index].name
                                            .toLowerCase()
                                            .contains(inventoryState.searchFilter.toLowerCase())) {
                                      String id, supplierCode;
                                      int isActive;
                                      bool attached;
                                      if (inventoryState.products[index].subWarehouseId != -1) {
                                        id = inventoryState.products[index].subWarehouseId.toString();
                                      } else {
                                        List<int> subWarehousesIds =
                                            StaticVariables.subWarehouses.map((warehouse) => warehouse.id).toList();
                                        List<int> productIds = inventoryState.products[index].warehouses
                                            .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                            .toList();
                                        subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                        if (subWarehousesIds.isNotEmpty) {
                                          id = subWarehousesIds[0].toString();
                                        } else if (inventoryState.products[index].warehouses.isNotEmpty) {
                                          id = inventoryState.products[index].warehouses[0].pivot.subWarehouseId;
                                        }
                                      }
                                      if (inventoryState.products[index].supplierCode != null) {
                                        supplierCode = inventoryState.products[index].supplierCode;
                                      } else if (inventoryState.products[index].warehouses.isNotEmpty) {
                                        supplierCode = inventoryState.products[index].warehouses
                                            .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                            .pivot
                                            .supplierCode;
                                      }
                                      if (inventoryState.products[index].isActive != 'null') {
                                        isActive = int.parse(inventoryState.products[index].isActive);
                                      } else if (inventoryState.products[index].warehouses.isNotEmpty) {
                                        isActive =
                                            int.parse(inventoryState.products[index].warehouses[0].pivot.isActive);
                                      }
                                      attached = false;
                                      if (inventoryState.products[index].supplierCode != 'null') {
                                        attached = true;
                                      } else if (inventoryState.products[index].warehouses != null) {
                                        if (inventoryState.products[index].warehouses.isNotEmpty) {
                                          attached = inventoryState.products[index].warehouses
                                              .map((warehouse) => warehouse.pivot.supplierCode)
                                              .toList()
                                              .where((code) => code != 'null')
                                              .toList()
                                              .isNotEmpty;
                                        }
                                      }
                                      return InventoryProductsViewCard(
                                        index: 0,
                                        id: id,
                                        onChangeSubWarehouse: (id) =>
                                            inventoryState.products[index].subWarehouseId = int.parse(id),
                                        attached: attached,
                                        isActive: isActive,
                                        supplierCode: supplierCode,
                                        price: inventoryState.products[index].price != '0'
                                            ? inventoryState.products[index].price
                                            : inventoryState.products[index].warehouses.isNotEmpty
                                                ? inventoryState.products[index].warehouses[0].pivot.price
                                                : '0',
                                        scaffoldKey: scaffoldKey,
                                        fromInventory:
                                            inventoryState.inventoryType == InventoryTypes.underCheckAvailability,
                                        productData: inventoryState.products[index],
                                        onChangeStatus: (result) {
                                          if (result) {
                                            store.dispatch(ClearInventory());
                                            List<ProductData> products = inventoryState.products;
                                            products.removeAt(index);
                                            store.dispatch(SetInventoryProducts(products: products));
                                          }
                                        },
                                        onDelete: (result) {
                                          if (result) {
                                            store.dispatch(ClearInventory());
                                            List<ProductData> products = inventoryState.products;
                                            products.removeAt(index);
                                            store.dispatch(SetInventoryProducts(products: products));
                                          }
                                        },
                                        onChangePrice: (newValue) => inventoryState.products[index].price = newValue,
                                        onChangeUnit: (newValue) => inventoryState.products[index].unit = newValue,
                                        onChangeQuantity: (newValue) =>
                                            inventoryState.products[index].quantity = newValue,
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: ((inventoryState.hasNext && state.loadingState.loading.isNotEmpty) ||
                              (!inventoryState.hasNext && inventoryState.products.isNotEmpty))
                          ? 50
                          : 0,
                      color: Colors.transparent,
                      child: Center(
                          child: inventoryState.hasNext && state.loadingState.loading.isNotEmpty
                              ? const Loader()
                              : !inventoryState.hasNext
                                  ? Text('تم جلب جميع المنتجات', style: paragraphStyle)
                                  : Container())),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

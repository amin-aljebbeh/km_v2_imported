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

  @override
  initState() {
    if (mounted) super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(StartLoading());
      StoreProvider.of<AppState>(context).dispatch(ClearInventory());
      StoreProvider.of<AppState>(context).dispatch(GetNotificationProducts());
    });
    controller.addListener(() =>
        setState(() => StoreProvider.of<AppState>(context).dispatch(SetSearchFilter(searchFilter: controller.text))));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: InventorySearchTextField(
              onReload: () {
                StoreProvider.of<AppState>(context).dispatch(StartLoading());
                StoreProvider.of<AppState>(context).dispatch(ClearInventory());
                StoreProvider.of<AppState>(context).dispatch(GetNotificationProducts());
              },
              controller: controller,
              context: context),
          body: Column(
            children: <Widget>[
              state.errorState.isError
                  ? Expanded(
                      child: Column(
                        children: [
                          AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'),
                          ElevatedButton(
                            child: Text(
                              'المحاولة من جديد',
                              style:
                                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: fontFamily),
                            ),
                            onPressed: () {
                              StoreProvider.of<AppState>(context).dispatch(StartLoading());
                              StoreProvider.of<AppState>(context).dispatch(ClearInventory());
                              StoreProvider.of<AppState>(context).dispatch(GetNotificationProducts());
                            },
                          ),
                        ],
                      ),
                    )
                  : state.inventoryState.products.isEmpty && !state.loadingState.isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Text('لا يوجد منتجات',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontFamily: fontFamily)),
                          ))
                      : Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!state.loadingState.isLoading &&
                                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                  state.inventoryState.hasNext) {
                                StoreProvider.of<AppState>(context).dispatch(StartLoading());
                                StoreProvider.of<AppState>(context).dispatch(NextPage());
                                StoreProvider.of<AppState>(context).dispatch(GetNotificationProducts());
                              }
                              return;
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount:
                                  state.inventoryState.products == null ? 0 : state.inventoryState.products.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (state.inventoryState.searchFilter == null ||
                                    state.inventoryState.searchFilter == '' ||
                                    state.inventoryState.products[index].name
                                        .toLowerCase()
                                        .contains(state.inventoryState.searchFilter.toLowerCase())) {
                                  String id, supplierCode;
                                  int isActive;
                                  bool attached;
                                  if (state.inventoryState.products[index].subWarehouseId != -1) {
                                    id = state.inventoryState.products[index].subWarehouseId.toString();
                                  } else {
                                    List<int> subWarehousesIds =
                                        LoadingScreenServices.subWarehouses.map((warehouse) => warehouse.id).toList();
                                    List<int> productIds = state.inventoryState.products[index].warehouses
                                        .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                        .toList();
                                    subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                    if (subWarehousesIds.isNotEmpty) {
                                      id = subWarehousesIds[0].toString();
                                    } else if (state.inventoryState.products[index].warehouses.isNotEmpty) {
                                      id = state.inventoryState.products[index].warehouses[0].pivot.subWarehouseId;
                                    }
                                  }
                                  if (state.inventoryState.products[index].supplierCode != null) {
                                    supplierCode = state.inventoryState.products[index].supplierCode;
                                  } else if (state.inventoryState.products[index].warehouses.isNotEmpty) {
                                    supplierCode = state.inventoryState.products[index].warehouses
                                        .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                        .pivot
                                        .supplierCode;
                                  }
                                  if (state.inventoryState.products[index].isActive != 'null') {
                                    isActive = int.parse(state.inventoryState.products[index].isActive);
                                  } else if (state.inventoryState.products[index].warehouses.isNotEmpty) {
                                    isActive =
                                        int.parse(state.inventoryState.products[index].warehouses[0].pivot.isActive);
                                  }
                                  attached = false;
                                  if (state.inventoryState.products[index].supplierCode != 'null') {
                                    attached = true;
                                  } else if (state.inventoryState.products[index].warehouses != null) {
                                    if (state.inventoryState.products[index].warehouses.isNotEmpty) {
                                      attached = state.inventoryState.products[index].warehouses
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
                                    attached: attached,
                                    isActive: isActive,
                                    supplierCode: supplierCode,
                                    price: state.inventoryState.products[index].price != '0'
                                        ? state.inventoryState.products[index].price
                                        : state.inventoryState.products[index].warehouses.isNotEmpty
                                            ? state.inventoryState.products[index].warehouses[0].pivot.price
                                            : '0',
                                    scaffoldKey: scaffoldKey,
                                    fromInventory: true,
                                    productData: state.inventoryState.products[index],
                                    onChangeStatus: (result) {
                                      if (result) setState(() => state.inventoryState.products.removeAt(index));
                                    },
                                    onDelete: (result) {
                                      if (result) setState(() => state.inventoryState.products.removeAt(index));
                                    },
                                    onChangePrice: (newValue) =>
                                        setState(() => state.inventoryState.products[index].price = newValue),
                                    onChangeUnit: (newValue) =>
                                        setState(() => state.inventoryState.products[index].unit = newValue),
                                    onChangeQuantity: (newValue) =>
                                        setState(() => state.inventoryState.products[index].quantity = newValue),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: ((state.inventoryState.hasNext && state.loadingState.isLoading) ||
                          (!state.inventoryState.hasNext))
                      ? 50
                      : 0,
                  color: Colors.transparent,
                  child: Center(
                      child: state.inventoryState.hasNext && state.loadingState.isLoading
                          ? const Loader()
                          : !state.inventoryState.hasNext
                              ? Text('تم جلب جميع المنتجات', style: paragraphStyle)
                              : Container())),
            ],
          ),
        );
      },
    );
  }
}

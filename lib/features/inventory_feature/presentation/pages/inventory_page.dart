import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/inventory_feature/presentation/redux/inventory_action.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../widgets/inventory_filter_widget.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => StoreProvider.of<AppState>(context).dispatch(InitialInventory(context: context)));
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
        List<ProductEntity> products = [];
        var inventoryState = state.inventoryState;
        products.addAll(inventoryState.products.where((product) =>
            ![InventoryTypes.notAdded, InventoryTypes.all].contains(store.state.inventoryState.inventoryType)));
        products.addAll(inventoryState.allProducts
            .where((product) => InventoryTypes.all == store.state.inventoryState.inventoryType));
        products.addAll(inventoryState.notAddedProducts
            .where((product) => InventoryTypes.notAdded == store.state.inventoryState.inventoryType));
        products.removeWhere((product) =>
            (inventoryState.searchFilter != null && inventoryState.searchFilter != '') &&
            !product.name.toLowerCase().contains(inventoryState.searchFilter.toLowerCase()));
        return Scaffold(
          key: scaffoldKey,
          floatingActionButton: inventoryState.inventoryType == InventoryTypes.prices
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: primaryColor,
                  child: Text(products.length.toString(), style: mainStyle.copyWith(fontSize: 20)),
                )
              : const SizedBox(),
          backgroundColor: Colors.white,
          appBar: InventorySearchTextField(
              onReload: () {
                if (state.inventoryState.inventoryType == InventoryTypes.all) {
                  StoreProvider.of<AppState>(context).dispatch(SetIAllProducts(products: []));
                }
                if (state.inventoryState.inventoryType == InventoryTypes.notAdded) {
                  StoreProvider.of<AppState>(context).dispatch(SetNotAddedProducts(products: []));
                }
                StoreProvider.of<AppState>(context).dispatch(InitialInventory(context: context));
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
                  if (![
                    InventoryTypes.notAdded,
                    InventoryTypes.all,
                    InventoryTypes.added,
                    InventoryTypes.barcode,
                    InventoryTypes.prices
                  ].contains(inventoryState.inventoryType))
                    const InventoryFilterWidget(),
                  state.errorState.isError
                      ? Expanded(
                          child: Column(
                            children: [
                              AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'),
                              KammunButton(
                                  onTap: () => store.dispatch(InitialInventory(context: context)),
                                  color: primaryColor,
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  text: 'المحاولة من جديد'),
                            ],
                          ),
                        )
                      : products.isEmpty && state.loadingState.loading.isEmpty
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
                                    store.dispatch(GetInventory(context: context));
                                  }
                                  return;
                                },
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: products.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String id, supplierCode;
                                    int isActive;
                                    bool attached;
                                    if (products[index].subWarehouseId != -1) {
                                      id = products[index].subWarehouseId.toString();
                                    } else {
                                      List<int> subWarehousesIds = state.generalInformationState.subWarehouses
                                          .map((warehouse) => warehouse.id)
                                          .toList();
                                      List<int> productIds = products[index]
                                          .warehouses
                                          .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                          .toList();
                                      subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                      if (subWarehousesIds.isNotEmpty) {
                                        id = subWarehousesIds[0].toString();
                                      } else if (products[index].warehouses.isNotEmpty) {
                                        id = products[index].warehouses[0].pivot.subWarehouseId;
                                      }
                                    }
                                    if (products[index].supplierCode != null &&
                                        products[index].supplierCode != 'null') {
                                      supplierCode = products[index].supplierCode;
                                    } else if (products[index].warehouses.isNotEmpty) {
                                      supplierCode = products[index]
                                          .warehouses
                                          .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                          .pivot
                                          .supplierCode;
                                    }
                                    if (products[index].isActive != 'null') {
                                      isActive = int.parse(products[index].isActive);
                                    } else if (products[index].warehouses.isNotEmpty) {
                                      isActive = int.parse(products[index].warehouses[0].pivot.isActive);
                                    }
                                    attached = false;
                                    if (products[index].supplierCode != 'null') {
                                      attached = true;
                                    } else if (products[index].warehouses != null) {
                                      if (products[index].warehouses.isNotEmpty) {
                                        attached = products[index]
                                            .warehouses
                                            .map((warehouse) => warehouse.pivot.supplierCode)
                                            .toList()
                                            .where((code) => code != 'null')
                                            .toList()
                                            .isNotEmpty;
                                      }
                                    }
                                    return InventoryProductWidget(
                                      index: 0,
                                      id: id,
                                      onChangeSubWarehouse: (id) => products[index].subWarehouseId = int.parse(id),
                                      attached: attached,
                                      isActive: isActive,
                                      supplierCode: supplierCode,
                                      price: products[index].price != '0'
                                          ? products[index].price
                                          : products[index].warehouses.isNotEmpty
                                              ? products[index].warehouses[0].pivot.price
                                              : '0',
                                      scaffoldKey: scaffoldKey,
                                      fromInventory:
                                          inventoryState.inventoryType == InventoryTypes.underCheckAvailability,
                                      productData: products[index],
                                      onChangeStatus: (result) {
                                        if (result) {
                                          store.dispatch(ClearInventory());
                                          List<ProductEntity> products = inventoryState.products;
                                          products.removeAt(index);
                                          store.dispatch(SetInventoryProducts(products: products));
                                        }
                                      },
                                      onDelete: (result) {
                                        if (result) {
                                          store.dispatch(ClearInventory());
                                          List<ProductEntity> products = inventoryState.products;
                                          products.removeAt(index);
                                          store.dispatch(SetInventoryProducts(products: products));
                                        }
                                      },
                                      onChangePrice: (newValue) => products[index].price = newValue,
                                      onChangeUnit: (newValue) => products[index].unit = newValue,
                                      onChangeQuantity: (newValue) => products[index].quantity = newValue,
                                    );
                                  },
                                ),
                              ),
                            ),
                  if (state.inventoryState.inventoryType == InventoryTypes.barcode)
                    KammunButton(
                      color: primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        state.barcodeState.onIgnore(state.barcodeState.barcodeString);
                      },
                      text: 'تجاهل',
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.95,
                    ),
                  if ((inventoryState.hasNext && state.loadingState.loading.isNotEmpty) ||
                      (!inventoryState.hasNext && products.isNotEmpty))
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                            child: inventoryState.hasNext && state.loadingState.loading.isNotEmpty
                                ? const Loader()
                                : !inventoryState.hasNext && inventoryState.inventoryType != InventoryTypes.barcode
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

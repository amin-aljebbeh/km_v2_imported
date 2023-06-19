import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../redux/products_filter_action.dart';
import '../widgets/product_filter_page_header_widget.dart';

class ProductsFilterPage extends StatefulWidget {
  const ProductsFilterPage({Key key}) : super(key: key);

  @override
  _ProductsFilterPageState createState() => _ProductsFilterPageState();
}

class _ProductsFilterPageState extends State<ProductsFilterPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => StoreProvider.of<AppState>(context)
        .dispatch(SetProductsFilterSearchString(searchString: searchController.text)));
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        var productsFilterState = state.productsFilterState;
        List<ProductEntity> products = [];
        products.addAll(productsFilterState.filteredProducts);
        products.removeWhere((product) =>
            (productsFilterState.productsFilterSearchString != null &&
                productsFilterState.productsFilterSearchString != '') &&
            !product.name.toLowerCase().contains(productsFilterState.productsFilterSearchString.toLowerCase()));
        return Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {},
            child: Text(productsFilterState.total.toString(),
                style: mainStyle.copyWith(fontSize: 20, color: Colors.white)),
          ),
          appBar: InventorySearchTextField(
              onReload: () {
                if (valueController.text.isNotEmpty ||
                    productsFilterState.filteredProductsTypes == FilteredProductsTypes.deleted) {
                  store.dispatch(InitProductsFilter(context: context));
                }
              },
              controller: searchController,
              context: context),
          body: SafeArea(
            child: Column(
              children: [
                ProductFilterPageHeaderWidget(controller: valueController),
                Expanded(
                  child: (valueController.text.isNotEmpty ||
                          productsFilterState.filteredProductsTypes == FilteredProductsTypes.deleted)
                      ? state.errorState.isError
                          ? Center(
                              child: AlertMessages(
                                  text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'))
                          : state.loadingState.loading.isNotEmpty
                              ? const Loader()
                              : products.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(75), child: ScreenMessage(message: 'لا يوجد منتجات'))
                                  : ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                      primary: false,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: products.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        ProductEntity eachProduct = products[index];
                                        String id, supplierCode;
                                        int isActive;
                                        bool attached;
                                        if (eachProduct.subWarehouseId != -1) {
                                          id = eachProduct.subWarehouseId.toString();
                                        } else {
                                          List<int> subWarehousesIds = state.generalInformationState.subWarehouses
                                              .map((warehouse) => warehouse.id)
                                              .toList();
                                          List<int> productIds = eachProduct.warehouses
                                              .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                              .toList();
                                          subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                          if (subWarehousesIds.isNotEmpty) {
                                            id = subWarehousesIds[0].toString();
                                          } else if (eachProduct.warehouses.isNotEmpty) {
                                            id = eachProduct.warehouses[0].pivot.subWarehouseId;
                                          }
                                        }
                                        if (eachProduct.supplierCode != null) {
                                          supplierCode = eachProduct.supplierCode;
                                        } else if (eachProduct.warehouses.isNotEmpty) {
                                          supplierCode = eachProduct.warehouses
                                              .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                              .pivot
                                              .supplierCode;
                                        }
                                        if (eachProduct.isActive != 'null') {
                                          isActive = int.parse(eachProduct.isActive);
                                        } else if (eachProduct.warehouses.isNotEmpty) {
                                          isActive = int.parse(eachProduct.warehouses[0].pivot.isActive);
                                        }
                                        attached = false;
                                        if (eachProduct.supplierCode != 'null') {
                                          attached = true;
                                        } else if (eachProduct.warehouses != null) {
                                          if (eachProduct.warehouses.isNotEmpty) {
                                            attached = eachProduct.warehouses
                                                .map((warehouse) => warehouse.pivot.supplierCode)
                                                .toList()
                                                .where((code) => code != 'null')
                                                .toList()
                                                .isNotEmpty;
                                          }
                                        }
                                        return InventoryProductWidget(
                                          index: 0,
                                          onChangeSubWarehouse: (id) {
                                            eachProduct.subWarehouseId = int.parse(id);
                                            products[index].subWarehouseId = int.parse(id);
                                          },
                                          id: id,
                                          attached: attached,
                                          isActive: isActive,
                                          supplierCode: supplierCode,
                                          price: products[index].price != '0'
                                              ? products[index].price
                                              : products[index].warehouses.isNotEmpty
                                                  ? products[index].warehouses[0].pivot.price
                                                  : '0',
                                          scaffoldKey: scaffoldKey,
                                          fromInventory: false,
                                          productData: eachProduct,
                                          onChangeStatus: (result) {
                                            if (result) {
                                              if (products[index].isActive == '1') {
                                                products[index].isActive = '0';
                                              } else {
                                                products[index].isActive = '1';
                                              }
                                            }
                                            setState(() {});
                                          },
                                          onDelete: (boolean) => setState(() {
                                            if (boolean) products.removeAt(index);
                                          }),
                                          deleteTimes: products[index].deleteTimes,
                                          onChangePrice: (newValue) => setState(() => products[index].price = newValue),
                                          onChangeUnit: (newValue) => setState(() => products[index].unit = newValue),
                                          onChangeQuantity: (newValue) =>
                                              setState(() => products[index].quantity = newValue),
                                        );
                                      },
                                    )
                      : Container(),
                ),
                if (!productsFilterState.hasNextFilteredProducts)
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.transparent,
                      child: Center(child: Text('تم جلب جميع المنتجات', style: paragraphStyle)))
              ],
            ),
          ),
        );
      },
    );
  }
}

import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../price_file_redux/price_file_action.dart';
import '../widget/inventory_products_widget.dart';

class PriceFileProduct extends StatefulWidget {
  const PriceFileProduct({Key key}) : super(key: key);

  @override
  _PriceFileProductState createState() => _PriceFileProductState();
}

class _PriceFileProductState extends State<PriceFileProduct> with AutomaticKeepAliveClientMixin<PriceFileProduct> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<ProductEntity> showList = [];
        switch (state.priceFileState.priceSelected) {
          case 1:
            showList.addAll(state.priceFileState.priceFileProductEntity.nonIntroducedProducts);
            break;
          case 0:
            showList.addAll(state.priceFileState.priceFileProductEntity.productsPriceChange);
            break;
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: primaryColor,
            child: Text(showList.length.toString(), style: appBarStyle.copyWith(fontSize: 20)),
          ),
          key: scaffoldKey,
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Center(
                    child: DropdownButton(
                      onChanged: (value) =>
                          StoreProvider.of<AppState>(context).dispatch(SetPriceSelected(selected: value)),
                      items: Services.dropdownStringList(['تغير سعرها', 'الغير المضافة']),
                      value: state.priceFileState.priceSelected,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: !state.priceFileState.priceSent
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: KammunButton(
                                onTap: () {
                                  StoreProvider.of<AppState>(context).dispatch(ImportProductPricesInWarehouseAction());
                                },
                                color: primaryColor,
                                height: 50,
                                text: 'إرسال الملف',
                              ),
                            ),
                          )
                        : state.priceFileState.error
                            ? Center(
                                child: AlertMessages(
                                  text: errorMessage,
                                  messageType: 'internetError',
                                  headerText: 'حدث خطأ أثناء رفع الملف',
                                ),
                              )
                            : state.priceFileState.loading
                                ? const Loader()
                                : showList.isEmpty
                                    ? Center(
                                        child: AlertMessages(
                                          text: 'لا يوجد منتجات في هذا القسم',
                                          messageType: 'Successfully',
                                          headerText: 'لا يوجد منتجات في هذا القسم',
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: showList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          String id, supplierCode;
                                          int isActive;
                                          bool attached;
                                          if (showList[index].subWarehouseId != -1) {
                                            id = showList[index].subWarehouseId.toString();
                                          } else {
                                            List<int> subWarehousesIds = state.generalInformationState.subWarehouses
                                                .map((warehouse) => warehouse.id)
                                                .toList();
                                            List<int> productIds = showList[index]
                                                .warehouses
                                                .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                                .toList();
                                            subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                            if (subWarehousesIds.isNotEmpty) {
                                              id = subWarehousesIds[0].toString();
                                            } else if (showList[index].warehouses.isNotEmpty) {
                                              id = showList[index].warehouses[0].pivot.subWarehouseId;
                                            }
                                          }
                                          if (showList[index].supplierCode != null) {
                                            supplierCode = showList[index].supplierCode;
                                          } else if (showList[index].warehouses.isNotEmpty) {
                                            supplierCode = showList[index]
                                                .warehouses
                                                .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                                .pivot
                                                .supplierCode;
                                          }
                                          if (showList[index].isActive != 'null') {
                                            isActive = int.parse(showList[index].isActive);
                                          } else if (showList[index].warehouses.isNotEmpty) {
                                            isActive = int.parse(showList[index].warehouses[0].pivot.isActive);
                                          }
                                          attached = false;
                                          if (showList[index].supplierCode != 'null') {
                                            attached = true;
                                          } else if (showList[index].warehouses != null) {
                                            if (showList[index].warehouses.isNotEmpty) {
                                              attached = showList[index]
                                                  .warehouses
                                                  .map((warehouse) => warehouse.pivot.supplierCode)
                                                  .toList()
                                                  .where((code) => code != 'null')
                                                  .toList()
                                                  .isNotEmpty;
                                            }
                                          }
                                          if (state.priceFileState.priceSelected == 1) attached = false;
                                          return InventoryProductCard(
                                            index: index,
                                            onChangeSubWarehouse: (id) =>
                                                showList[index].subWarehouseId = int.parse(id),
                                            id: id,
                                            attached: attached,
                                            isActive: isActive,
                                            supplierCode: supplierCode,
                                            scaffoldKey: scaffoldKey,
                                            productData: showList[index],
                                            price: (int.parse(showList[index].price.split('.')[0]) +
                                                    int.parse(showList[index].priceChange.split('.')[0]))
                                                .toString(),
                                            fromInventory: false,
                                            oldPrice: int.parse(showList[index].price.split('.')[0]),
                                            onChangeStatus: (result) {
                                              if (result) showList[index] = showList.removeLast();
                                              setState(() {});
                                            },
                                            onChangePrice: (newValue) =>
                                                setState(() => showList[index].price = newValue),
                                            onChangeUnit: (newValue) => setState(() => showList[index].unit = newValue),
                                            onChangeQuantity: (newValue) =>
                                                setState(() => showList[index].quantity = newValue),
                                          );
                                        },
                                      ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

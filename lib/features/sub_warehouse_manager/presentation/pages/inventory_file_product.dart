import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/sub_warehouse_manager/presentation/widget/inventory_products_widget.dart';

import '../../../../core/core_importer.dart';
import '../inventory_file_redux/inventory_file_action.dart';

class InventoryFileProduct extends StatefulWidget {
  const InventoryFileProduct({Key key}) : super(key: key);

  @override
  _InventoryFileProductState createState() => _InventoryFileProductState();
}

class _InventoryFileProductState extends State<InventoryFileProduct>
    with AutomaticKeepAliveClientMixin<InventoryFileProduct> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        List<ProductEntity> showList = [];
        switch (state.inventoryFileState.productsSelected) {
          case 0:
            showList.addAll(state.inventoryFileState.inventoryFileProductEntity.nonIntroducedProducts);
            break;
          case 1:
            showList.addAll(state.inventoryFileState.inventoryFileProductEntity.toActiveList);
            break;
          case 2:
            showList.addAll(state.inventoryFileState.inventoryFileProductEntity.toDeActiveList);
            break;
          case 3:
            showList.addAll(state.inventoryFileState.inventoryFileProductEntity.activatedList);
            break;
        }
        return Scaffold(
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: primaryColor,
            child: Text(showList.length.toString(), style: appBarStyle.copyWith(fontSize: 20)),
          ),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Center(
                    child: DropdownButton(
                        onChanged: (value) =>
                            StoreProvider.of<AppState>(context).dispatch(SetProductsSelected(selected: value)),
                        items: Services.dropdownStringList(
                            ['الغير المضافة', 'بحاجة تفعيل', 'بحاجة إيقاف تفعيل', 'تم تفعيلها']),
                        value: state.inventoryFileState.productsSelected),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: !state.inventoryFileState.productsSent
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: KammunButton(
                                onTap: () => StoreProvider.of<AppState>(context)
                                    .dispatch(ImportProductActivationInWarehouseAction()),
                                color: primaryColor,
                                height: 50,
                                text: 'إرسال الملف',
                              ),
                            ),
                          )
                        : state.inventoryFileState.error
                            ? Center(
                                child: AlertMessages(
                                text: errorMessage,
                                messageType: 'internetError',
                                headerText: 'حدث خطأ أثناء رفع الملف',
                              ))
                            : state.inventoryFileState.loading
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
                                          if (state.inventoryFileState.productsSelected == 0) attached = false;
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
                                            price: showList[index].price,
                                            fromInventory: false,
                                            onChangeStatus: (result) => setState(() {
                                              if (result) showList.removeAt(index);
                                            }),
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

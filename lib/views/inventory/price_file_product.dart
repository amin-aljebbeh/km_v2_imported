import 'package:kammun_app/views/loading/loading_services.dart';

import '../../core/core_importer.dart';
import 'model/inventory_model_importer.dart';
import 'services/inventory_services.dart';

class PriceFileProduct extends StatefulWidget {
  final File file;
  final String subWarehouseId;

  const PriceFileProduct({Key key, @required this.subWarehouseId, @required this.file}) : super(key: key);
  @override
  _PriceFileProductState createState() => _PriceFileProductState();
}

class _PriceFileProductState extends State<PriceFileProduct> with AutomaticKeepAliveClientMixin<PriceFileProduct> {
  PriceFileProductModel importedProducts = PriceFileProductModel();
  List<ProductData> showList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool sent;
  bool error;
  bool loading;
  int selectedList;

  assignArray() {
    setState(() {
      showList = [];
      switch (selectedList) {
        case 1:
          showList.addAll(importedProducts.nonIntroducedProducts);
          break;
        case 0:
          showList.addAll(importedProducts.productsPriceChange);
          break;
      }
    });
  }

  loadData() async {
    var response =
        await InventoryServices.fromFileChangedPriceProducts(file: widget.file, subWarehouseId: widget.subWarehouseId);
    setState(() {
      loading = false;
      if (response == null) {
        error = true;
      } else {
        error = false;
        importedProducts = response;
        assignArray();
      }
    });
  }

  @override
  void initState() {
    selectedList = 0;
    loading = false;
    error = false;
    sent = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Text(showList.length.toString(), style: const TextStyle(fontSize: 20)),
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Center(
                child: DropdownButton(
                  onChanged: (value) => setState(() {
                    selectedList = value;
                    assignArray();
                  }),
                  items: Services.dropdownStringList(['تغير سعرها', 'الغير المضافة']),
                  value: selectedList,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: !sent
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: KammunButton(
                            onTap: () {
                              setState(() {
                                sent = true;
                                loading = true;
                              });
                              loadData();
                            },
                            color: primaryColor,
                            height: 50,
                            text: 'إرسال الملف',
                          ),
                        ),
                      )
                    : error
                        ? Center(
                            child: AlertMessages(
                              text: errorMessage,
                              messageType: 'internetError',
                              headerText: 'حدث خطأ أثناء رفع الملف',
                            ),
                          )
                        : loading
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
                                        List<int> subWarehousesIds = LoadingScreenServices.subWarehouses
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
                                      if (selectedList == 1) attached = false;
                                      return InventoryProductsViewCard(
                                        index: index,
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
                                          if (result) setState(() => showList[index] = showList.removeLast());
                                        },
                                        onChangePrice: (newValue) => setState(() => showList[index].price = newValue),
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
  }

  @override
  bool get wantKeepAlive => true;
}

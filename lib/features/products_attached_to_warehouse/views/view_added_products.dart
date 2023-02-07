import 'package:kammun_app/features/products_attached_to_warehouse/services/added_products_services.dart';

import '../../../core/core_importer.dart';

class AddedProductsToWarehouse extends StatefulWidget {
  static const String routeName = '/AddedProductsToWarehouse';
  const AddedProductsToWarehouse({Key key}) : super(key: key);

  @override
  _AddedProductsToWarehouseState createState() => _AddedProductsToWarehouseState();
}

class _AddedProductsToWarehouseState extends State<AddedProductsToWarehouse> {
  List<ProductData> productsList = [];
  bool isLoading = false;
  bool isError = false;
  final TextEditingController _controller = TextEditingController();
  String filter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await AddedProductsServices.getAddedProductsToWarehouseService();
      if (response != null) {
        productsList.addAll(response);
        setState(() => isLoading = false);
        return true;
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        return false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      return false;
    }
  }

  @override
  initState() {
    if (mounted) super.initState();
    _loadData();

    _controller.addListener(() => setState(() => filter = _controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: InventorySearchTextField(onReload: () => _loadData(), controller: _controller, context: context),
      body: Column(
        children: <Widget>[
          isLoading
              ? const Center(child: Padding(padding: EdgeInsets.only(top: 30.0), child: Loader()))
              : isError
                  ? Center(
                      child: Expanded(
                        child: Column(
                          children: [
                            AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'),
                            ElevatedButton(child: Text(tryAgain, style: blackBold), onPressed: () => _loadData())
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: productsList == null ? 0 : productsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var eachProduct = productsList[index];
                          try {
                            if (filter == null ||
                                filter == '' ||
                                eachProduct.description.toLowerCase().contains(filter.toLowerCase())) {
                              String id, supplierCode;
                              int isActive;
                              bool attached;
                              if (productsList[index].subWarehouseId != -1) {
                                id = productsList[index].subWarehouseId.toString();
                              } else {
                                List<int> subWarehousesIds =
                                    LoadingScreenServices.subWarehouses.map((warehouse) => warehouse.id).toList();
                                List<int> productIds = productsList[index]
                                    .warehouses
                                    .map((warehouse) => int.parse(warehouse.pivot.subWarehouseId))
                                    .toList();
                                subWarehousesIds.removeWhere((id) => !productIds.contains(id));
                                if (subWarehousesIds.isNotEmpty) {
                                  id = subWarehousesIds[0].toString();
                                } else if (productsList[index].warehouses.isNotEmpty) {
                                  id = productsList[index].warehouses[0].pivot.subWarehouseId;
                                }
                              }
                              if (productsList[index].supplierCode != null) {
                                supplierCode = productsList[index].supplierCode;
                              } else if (productsList[index].warehouses.isNotEmpty) {
                                supplierCode = productsList[index]
                                    .warehouses
                                    .firstWhere((warehouse) => warehouse.pivot.supplierCode != 'null')
                                    .pivot
                                    .supplierCode;
                              }
                              if (productsList[index].isActive != 'null') {
                                isActive = int.parse(productsList[index].isActive);
                              } else if (productsList[index].warehouses.isNotEmpty) {
                                isActive = int.parse(productsList[index].warehouses[0].pivot.isActive);
                              }
                              attached = false;
                              if (productsList[index].supplierCode != 'null') {
                                attached = true;
                              } else if (productsList[index].warehouses != null) {
                                if (productsList[index].warehouses.isNotEmpty) {
                                  attached = productsList[index]
                                      .warehouses
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
                                    setState(() => productsList[index].subWarehouseId = int.parse(id)),
                                attached: attached,
                                isActive: isActive,
                                supplierCode: supplierCode,
                                price: productsList[index].price != '0'
                                    ? productsList[index].price
                                    : productsList[index].warehouses.isNotEmpty
                                        ? productsList[index].warehouses[0].pivot.price
                                        : '0',
                                scaffoldKey: scaffoldKey,
                                fromInventory: false,
                                onDelete: (result) {
                                  if (result) {
                                    setState(() {
                                      productsList.removeAt(index);
                                    });
                                  }
                                },
                                productData: eachProduct,
                                onChangeStatus: (result) {
                                  if (result) {
                                    setState(() {
                                      if (productsList[index].isActive == '1') {
                                        productsList[index].isActive = '0';
                                      } else {
                                        productsList[index].isActive = '1';
                                      }
                                    });
                                  }
                                },
                                onChangePrice: (newValue) => setState(() => productsList[index].price = newValue),
                                onChangeUnit: (newValue) => setState(() => productsList[index].unit = newValue),
                                onChangeQuantity: (newValue) => setState(() => productsList[index].quantity = newValue),
                              );
                            }
                          } catch (e) {/**/}
                          return Container();
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

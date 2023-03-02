import 'package:kammun_app/features/inventory/services/inventory_services.dart';

import '../../core/core_importer.dart';

class SubWarehouseProducts extends StatefulWidget {
  final String subWarehouseId;

  const SubWarehouseProducts({Key key, this.subWarehouseId}) : super(key: key);

  @override
  _SubWarehouseProductsState createState() => _SubWarehouseProductsState();
}

class _SubWarehouseProductsState extends State<SubWarehouseProducts> {
  List<ProductData> productsList = [];
  bool isLoading = false;
  bool isError = false;
  bool displayToActiveProducts = true;
  final TextEditingController _controller = TextEditingController();
  String filter;
  int filterProducts;
  int isActiveFilter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await InventoryServices.getSubWarehouseProductsService(subWarehouseId: widget.subWarehouseId);
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

    filterProducts = 0;
    isActiveFilter = 0;

    _controller.addListener(() => setState(() => filter = _controller.text));
  }

  int filterIndex = 0;

  _filterProducts() {
    if (filterIndex == 0) {
      setState(() {
        productsList.sort((a, b) {
          if (int.parse(a.isActive) == 0) {
            return -1;
          } else {
            return 1;
          }
        });
        filterIndex = 1;
      });
      snackBar(success: true, message: 'فرز حسب المواد الغير مفعلة', context: context);
    } else if (filterIndex == 1) {
      setState(() {
        productsList.sort((a, b) {
          if (int.parse(a.isActive) == 0) {
            return 1;
          } else {
            return -1;
          }
        });
        filterIndex = 2;
      });
      snackBar(success: true, message: 'فرز حسب المواد  المفعلة', context: context);
    } else if (filterIndex == 2) {
      setState(() {
        productsList.sort((a, b) {
          if (a.id > b.id) {
            return -1;
          } else if (a.id < b.id) {
            return 1;
          } else {
            return 0;
          }
        });
        filterIndex = 0;
      });
      snackBar(success: true, message: 'فرز حسب المواد المضافة حديثاً', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () => _filterProducts(),
          child: const Icon(Icons.filter_list_rounded, size: 35)),
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
                            ElevatedButton(child: Text(tryAgain, style: blackBold), onPressed: () => _loadData()),
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
                          if (filter == null ||
                              filter == '' ||
                              eachProduct.name.toLowerCase().contains(filter.toLowerCase())) {
                            String id, supplierCode;
                            int isActive;
                            bool attached;
                            if (eachProduct.subWarehouseId != -1) {
                              id = eachProduct.subWarehouseId.toString();
                            } else {
                              List<int> subWarehousesIds =
                                  StaticVariables.subWarehouses.map((warehouse) => warehouse.id).toList();
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
                            return InventoryProductsViewCard(
                              index: 0,
                              onChangeSubWarehouse: (id) =>
                                  setState(() => productsList[index].subWarehouseId = int.parse(id)),
                              id: id,
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
                                if (result) setState(() => productsList.removeAt(index));
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
                          return Container();
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

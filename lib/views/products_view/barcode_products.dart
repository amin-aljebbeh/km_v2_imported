import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

class BarcodeProducts extends StatefulWidget {
  final String barcode;
  final Function onIgnore;
  final BarcodeRequestType requestType;

  const BarcodeProducts({Key key, @required this.barcode, this.onIgnore, @required this.requestType}) : super(key: key);
  @override
  _BarcodeProductsState createState() => _BarcodeProductsState();
}

class _BarcodeProductsState extends State<BarcodeProducts> {
  List<ProductData> productsList = [];
  bool isLoading = false;
  bool isError = false;
  bool displayToActiveProducts = true;
  final TextEditingController _controller = TextEditingController();
  String filter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _loadData() async {
    productsList.clear();
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      List<ProductData> response;
      if (widget.requestType == BarcodeRequestType.addProduct || widget.requestType == BarcodeRequestType.addBarcode) {
        response = await ProductsServices.checkProductBarcodeService(bareCode: widget.barcode);
      } else {
        response = await ProductsServices.searchProductByBarcodeService(bareCode: widget.barcode);
      }
      if (response != null) {
        productsList.addAll(response);
        if (productsList.isEmpty) {
          Navigator.of(context).pop();
          widget.onIgnore();
        }
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: isLoading
                  ? const Center(child: Padding(padding: EdgeInsets.only(top: 30.0), child: Loader()))
                  : isError
                      ? Center(
                          child: Expanded(
                            child: Column(
                              children: [
                                AlertMessages(
                                    text: StringUtils.errorMessage,
                                    messageType: 'internetError',
                                    headerText: 'حدث خطأ'),
                                ElevatedButton(
                                    child: Text(StringUtils.tryAgain, style: blackBold), onPressed: () => _loadData())
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
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
                                  eachProduct.name.toLowerCase().contains(filter.toLowerCase())) {
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
                                  index: index + 100,
                                  id: id,
                                  attached: attached,
                                  isActive: isActive,
                                  supplierCode: supplierCode,
                                  price: productsList[index].price != '0'
                                      ? productsList[index].price
                                      : productsList[index].warehouses.isNotEmpty
                                          ? productsList[index].warehouses[0].pivot.price
                                          : '0',
                                  barcode: widget.barcode,
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
                                  onChangeQuantity: (newValue) =>
                                      setState(() => productsList[index].quantity = newValue),
                                );
                              }
                            } catch (e) {/**/}
                            return Container();
                          },
                        ),
            ),
            KammunButton(
              color: ColorUtils.primaryColor,
              onTap: () {
                Navigator.pop(context);
                widget.onIgnore();
              },
              text: 'تجاهل',
              height: 50,
              width: MediaQuery.of(context).size.width * 0.95,
            )
          ],
        ),
      ),
    );
  }
}

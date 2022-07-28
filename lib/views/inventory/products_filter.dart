import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/inventory/services/inventory_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/widget/close_widget.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import '../../service.dart';

class ProductsFilterScreen extends StatefulWidget {
  const ProductsFilterScreen({Key key}) : super(key: key);

  @override
  _ProductsFilterScreenState createState() => _ProductsFilterScreenState();
}

class _ProductsFilterScreenState extends State<ProductsFilterScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _fromDateTimeValue = "يرجى أختيار تاريخ البداية";
  String _toDateTimeValue = "يرجى إختيار تاريخ النهاية";

  bool empty;
  bool loading;
  bool error;
  int biggerThan;
  int page;
  int filter;
  String searchFilter;
  List<ProductData> productsList = [];
  int total;

  @override
  void initState() {
    super.initState();
    biggerThan = 1;
    total = 0;
    empty = false;
    page = 1;
    error = false;
    loading = false;
    searchController.addListener(() {
      setState(() {
        searchFilter = searchController.text;
      });
    });
  }

  getProducts() async {
    if (filter == 0 && int.parse(valueController.text) <= 5) {
      Toast.show("يرجى إدخال عدد أيام أكبر من 5", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    setState(() {
      empty = false;
      loading = true;
      if (productsList != null) productsList.clear();
    });
    var response = await InventoryServices.getFilteredProducts(
        page: page,
        filterIndex: filter,
        number: valueController.text,
        biggerThan: biggerThan,
        fromDate: _fromDateTimeValue,
        toDate: _toDateTimeValue);
    setState(() {
      loading = false;
      if (response != null) {
        total = response.total;
        error = false;
        if (response.products.isEmpty) empty = true;
        productsList = response.products;
      } else {
        error = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtils.primaryColor,
        onPressed: () {},
        child: Text(
          total.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      appBar: InventorySearchTextField(
        onReload: () {
          if ((valueController.text.isNotEmpty || filter == 3) && filter != null) getProducts();
        },
        controller: searchController,
        context: context,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: ColorUtils.primaryColor,
                  ),
                  onPressed: () {
                    if (!empty && (valueController.text.isNotEmpty || filter == 3) && filter != null) {
                      setState(() {
                        page++;
                      });
                      getProducts();
                    }
                  },
                ),
                DropdownButton(
                  hint: Text(
                    'فلترة المنتجات',
                    style: dropdownItemStyle,
                  ),
                  value: filter,
                  items: Services.dropdownStringList(StringUtils.productFilter),
                  onChanged: (value) {
                    if (value == 3) {
                      showMyDialog(
                        title: 'اختر تاريخ',
                        dialogButtons: [
                          const CloseWidget(),
                          DialogButton(
                            text: StringUtils.send,
                            onTap: () {
                              if (validDates()) {
                                Navigator.of(context).pop();
                                setState(() {
                                  filter = value;
                                  page = 1;
                                  loading = true;
                                });
                                getProducts();
                              } else {
                                Toast.show('الرجاء إدخال كافة البيانات', context,
                                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                              }
                            },
                          )
                        ],
                        content: KDatePicker(
                          onConfirmStart: (date) {
                            setState(() {
                              _fromDateTimeValue = date;
                            });
                          },
                          onConfirmEnd: (date) {
                            setState(() {
                              _toDateTimeValue = date;
                            });
                          },
                        ),
                      );
                    } else {
                      setState(() {
                        filter = value;
                        page = 1;
                      });
                      if (valueController.text.isNotEmpty) {
                        getProducts();
                      }
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    biggerThan == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 40,
                    color: ColorUtils.primaryColor,
                  ),
                  onPressed: () {
                    if (valueController.text.isNotEmpty && filter != null && filter != 3) {
                      setState(() {
                        if (biggerThan == 1) {
                          biggerThan = 0;
                        } else {
                          biggerThan = 1;
                        }
                      });
                      getProducts();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: EntryField(
                    onSubmit: (value) {
                      if (filter != null) {
                        setState(() {});
                        getProducts();
                      }
                    },
                    controller: valueController,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 40,
                    color: ColorUtils.primaryColor,
                  ),
                  onPressed: () {
                    if ((valueController.text.isNotEmpty || filter == 3) && filter != null) {
                      setState(() {
                        if (page > 1) {
                          page--;
                        }
                      });
                      getProducts();
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.78,
              child: (valueController.text.isNotEmpty || filter == 3) && filter != null
                  ? error
                      ? Center(
                          child: AlertMessages(
                            text: StringUtils.errorMessage,
                            messageType: "internetError",
                            headerText: "حدث خطأ",
                          ),
                        )
                      : loading
                          ? const Loader()
                          : empty
                              ? const Padding(
                                  padding: EdgeInsets.all(75),
                                  child: ScreenMessage(
                                    message: 'لا يوجد منتجات',
                                  ),
                                )
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: productsList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    ProductData eachProduct = productsList[index];
                                    if (searchFilter == null ||
                                        searchFilter == "" ||
                                        eachProduct.name.toLowerCase().contains(searchFilter.toLowerCase())) {
                                      String id, supplierCode;
                                      int isActive;
                                      bool attached;
                                      if (eachProduct.subWarehouseId != -1) {
                                        id = eachProduct.subWarehouseId.toString();
                                      } else {
                                        List<int> subWarehousesIds = LoadingScreenServices.subWarehouses
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
                                      return InventoryProductsViewCard(
                                        index: 0,
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
                                        productData: eachProduct,
                                        onChangeStatus: (result) {
                                          if (result) {
                                            setState(() {
                                              if (productsList[index].isActive == "1") {
                                                productsList[index].isActive = "0";
                                              } else {
                                                productsList[index].isActive = "1";
                                              }
                                            });
                                          }
                                        },
                                        onDelete: (boolean) {
                                          setState(() {
                                            if (boolean) {
                                              setState(() {
                                                productsList.removeAt(index);
                                              });
                                            }
                                          });
                                        },
                                        deleteTimes: productsList[index].deleteTimes,
                                        onChangePrice: (newValue) {
                                          setState(() {
                                            productsList[index].price = newValue;
                                          });
                                        },
                                        onChangeUnit: (newValue) {
                                          setState(() {
                                            productsList[index].unit = newValue;
                                          });
                                        },
                                        onChangeQuantity: (newValue) {
                                          setState(() {
                                            productsList[index].quantity = newValue;
                                          });
                                        },
                                      );
                                    }
                                    return Container();
                                  },
                                )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  bool validDates() {
    return _fromDateTimeValue != "يرجى أختيار تاريخ البداية" && _toDateTimeValue != "يرجى إختيار تاريخ النهاية";
  }
}

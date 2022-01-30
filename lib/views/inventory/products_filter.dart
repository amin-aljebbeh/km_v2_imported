import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/inventory/services/inventory_services.dart';

import '../../Services.dart';

class ProductsFilterScreen extends StatefulWidget {
  @override
  _ProductsFilterScreenState createState() => _ProductsFilterScreenState();
}

class _ProductsFilterScreenState extends State<ProductsFilterScreen> {
  TextEditingController searchController = new TextEditingController();
  TextEditingController valueController = new TextEditingController();

  bool empty;
  bool selected;
  bool loading;
  bool error;
  int page;
  int filter;
  String searchFilter;
  List<ProductData> productsList = List<ProductData>();

  @override
  void initState() {
    super.initState();
    empty = false;
    selected = false;
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
    if (filter == 0 && int.parse(valueController.text) <= 14) {
      Toast.show("يرجى إدخال عدد أيام أكبر من 14", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    setState(() {
      empty = false;
      loading = true;
      if (productsList != null) productsList.clear();
    });
    var products =
        await InventoryServices.getFilteredProducts(page: page, filterIndex: filter, number: valueController.text);
    setState(() {
      loading = false;
      if (products != null) {
        error = false;
        if (products.isEmpty) empty = true;
        productsList = products;
      } else {
        error = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                  ),
              border: Border.all(color: ColorUtils.primaryColor, width: 2)),
          child: TextField(
            style: TextStyle(color: Colors.white, fontFamily: StringUtils.fontFamilyHKGrotesk),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.kmColors),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.kmColors),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.kmColors),
              ),
            ),
            cursorColor: ColorUtils.kmColors,
            controller: searchController,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {
                if (valueController.text.isNotEmpty && selected) getProducts();
              },
              icon: Icon(
                Icons.refresh,
                size: 35,
              ),
            ),
          )
        ],
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
                    if (valueController.text.isNotEmpty && !empty && selected) {
                      setState(() {
                        page++;
                        loading = true;
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
                    setState(() {
                      filter = value;
                      page = 1;
                      selected = true;
                    });
                    if (valueController.text.isNotEmpty) {
                      getProducts();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: EntryField(
                    onSubmit: (value) {
                      if (selected) {
                        setState(() {});
                        getProducts();
                      }
                    },
                    width: MediaQuery.of(context).size.width * 0.3,
                    canBeEmpty: false,
                    isAddress: false,
                    isPhoneNumber: false,
                    controller: valueController,
                    fieldType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 40,
                    color: ColorUtils.primaryColor,
                  ),
                  onPressed: () {
                    if (valueController.text.isNotEmpty && selected) {
                      setState(() {
                        if (page > 1) {
                          page--;
                          loading = true;
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.78,
              child: valueController.text.isNotEmpty && selected
                  ? error
                      ? Center(
                          child: AlertMessages(
                            text: StringUtils.errorMessage,
                            messageType: "internetError",
                            headerText: "حدث خطأ",
                          ),
                        )
                      : loading
                          ? Loader()
                          : empty
                              ? Padding(
                                  padding: const EdgeInsets.all(75),
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
                                      return InventoryProductsViewCard(
                                        attached: eachProduct.warehouses.isNotEmpty
                                            ? eachProduct.warehouses[0].pivot.supplierCode != null
                                                ? true
                                                : false
                                            : false,
                                        fromInventory: false,
                                        productData: eachProduct,
                                        onChangeStatus: (result) {
                                          if (result) {
                                            setState(() {
                                              productsList.removeAt(index);
                                            });
                                          }
                                        },
                                        active: eachProduct.warehouses.isNotEmpty
                                            ? int.parse(eachProduct.warehouses[0].pivot.isActive)
                                            : 0,
                                        onDelete: (bool) {
                                          setState(() {
                                            eachProduct.warehouses[0].pivot.supplierCode = null;
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
}

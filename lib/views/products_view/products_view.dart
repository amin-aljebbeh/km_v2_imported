import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/funny_images.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/products_view/add_products.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import 'barcode_screen.dart';

class ProductsView extends StatefulWidget {
  final String categoryId;
  final String queryString;
  final String barcode;

  ProductsView({@required this.categoryId, this.queryString, this.barcode});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewState();
  }
}

class ProductsViewState extends State<ProductsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool firstLoading = false;
  int page = 1;
  List<ProductData> productsList = List<ProductData>();
  bool searchLoading = false;
  bool theEndOfProducts = false;
  String errorMessage = "لم يتم العثور على المنتج";

  final _random = new Random();

  bool badWordMatched = false;

  Future<bool> _loadData(String query, ProductsViewTypes type) async {
    setState(() {
      badWordMatched = false;
    });
    String url = "";
    if (badWord.contains(query)) {
      setState(() {
        badWordMatched = true;
      });
    }
    if (!badWordMatched) {
      switch (type) {
        case ProductsViewTypes.search:
          url = SEARCH_PRODUCTS + "$query?page=" + page.toString();
          break;
        case ProductsViewTypes.category:
          url = GET_CATEGORY + "$query?page=$page";
          break;
        case ProductsViewTypes.barcode:
          url = SEARCH_PRODUCT_BY_BARCODE + query;
          break;
      }

      if (!theEndOfProducts) {
        try {
          var response = await ApiProvider.sendRequest(
            url: url,
            method: httpMethods.get,
          );
          if (response.statusCode == SUCCESS_CODE) {
            if (!response.data["success"] && response.data["reason"] == "No results") {
              setState(() {
                searchLoading = false;
                if (firstLoading == true) firstLoading = false;
                isLoading = false;
                if (productsList.length != 0) {
                  theEndOfProducts = true;
                }
              });
            } else {
              var products;
              switch (type) {
                case ProductsViewTypes.search:
                case ProductsViewTypes.category:
                  products = categoryProductFromJson(jsonEncode(response.data));
                  productsList.addAll(products.data.data);
                  break;
                case ProductsViewTypes.barcode:
                  products = syncCartFromJson(jsonEncode(response.data['data']));
                  setState(() {
                    productsList.clear();
                    productsList = syncCartFromJson(jsonEncode(response.data['data']));
                  });
                  break;
              }

              if (this.mounted) {
                setState(() {
                  if (type != ProductsViewTypes.barcode && page - 1 == products.data.lastPage) {
                    theEndOfProducts = true;
                  }
                  searchLoading = false;

                  if (firstLoading == true) firstLoading = false;
                  isLoading = false;
                });
              }
            }
            if (response.statusCode == 200)
              return true;
            else
              return false;
          } else {
            setState(() {
              errorMessage = "حدث خطأ أثناء محاولة جلب البيانات \n يرجى التحقق من إتصالك بالأنترنت";
              isLoading = false;
              searchLoading = false;
              firstLoading = false;
            });
          }
        } catch (e) {
          Tools.logToConsole(e.toString());
        }
      } else {
        return false;
      }
      return false;
    } else {}
    return false;
  }

  @override
  initState() {
    if (this.mounted) {
      super.initState();
    }
    if (widget.barcode != null) {
      _loadData(widget.barcode, ProductsViewTypes.barcode);
    } else if (widget.queryString != null) {
      _loadData(widget.queryString, ProductsViewTypes.search);
      searchController.text = widget.queryString;
    } else {
      _loadData(widget.categoryId, ProductsViewTypes.category);
    }
    setState(() {
      firstLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: widget.queryString == null &&
              widget.barcode == null &&
              (Services.isAdmin() || Services.isSuperAdmin() || Services.isProductsController())
          ? FloatingActionButton(
              backgroundColor: ColorUtils.kmColors2,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarCodeScreen(
                      requestType: BarcodeRequestType.addProduct,
                      onIgnore: (barcode) {
                        int param;
                        if (barcode == null) {
                          param = null;
                        } else {
                          param = int.parse(barcode);
                        }
                        Navigator.push(
                          scaffoldKey.currentContext,
                          new MaterialPageRoute(
                            builder: (screenContext) => new AddProductsView(
                              categoryId: widget.categoryId,
                              barcode: param,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              tooltip: 'Pick Image',
              child: Icon(Icons.add),
            )
          : null,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 210, 178, 2),
          automaticallyImplyLeading: false, // hides leading widget
          flexibleSpace: SafeArea(
            top: true,
            left: false,
            bottom: false,
            right: false,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          size: 35,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                    AppBarKammunImage(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(true),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                StoreSearchTextField(
                  scaffoldKey: scaffoldKey,
                  searchController: searchController,
                  onSubmit: () {
                    setState(() {
                      productsList.clear();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(105.0),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: badWordMatched
            ? Container(
                child: Center(
                  child: funnyImages[_random.nextInt(funnyImages.length)],
                ),
              )
            : productsList.length == 0
                ? (searchLoading || firstLoading)
                    ? FacebookLoader()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(errorMessage, style: mainStyle),
                        ),
                      )
                : Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                                setState(() {
                                  page++;
                                  isLoading = true;
                                });
                                searchController.text != ""
                                    ? _loadData(searchController.text, ProductsViewTypes.search)
                                    : _loadData(widget.categoryId, ProductsViewTypes.category);
                              }
                              return;
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: productsList == null ? 0 : productsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var eachProduct = productsList[index];
                                return ProductsViewCard(
                                  productData: eachProduct,
                                  index: index,
                                  scaffoldKey: scaffoldKey,
                                  onAddBarcode: (result) {
                                    if (result != 'error') {
                                      setState(() {
                                        productsList[index].barcodes.add(Barcode(
                                              barcode: result,
                                            ));
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: isLoading ? 50.0 : 0,
                          color: Colors.transparent,
                          child: Center(
                            child: widget.barcode == null
                                ? theEndOfProducts
                                    ? Text(
                                        "تم جلب جميع المنتجات",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        ),
                                      )
                                    : Loader()
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

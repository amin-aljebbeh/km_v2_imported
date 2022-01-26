import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/core/api/api_importer.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/funny_images.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_view/add_products.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class ProductsView extends StatefulWidget {
  final int heroIndex;
  final String categoryId;
  final String queryString;

  ProductsView({this.heroIndex, @required this.categoryId, this.queryString});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewState();
  }
}

class ProductsViewState extends State<ProductsView> {
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

  Future<bool> _loadData(String query, String type) async {
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
      if (type == "search") {
        url = "/api/product/search/$query?page=" + page.toString();
      } else {
        url = "/api/category/$query?page=$page";
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
              final products = categoryProductFromJson(jsonEncode(response.data));
              productsList.addAll(products.data.data);

              if (this.mounted) {
                setState(() {
                  if (page - 1 == products.data.lastPage) {
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
    if (widget.queryString != null) {
      _loadData(widget.queryString, "search");
      searchController.text = widget.queryString;
    } else {
      _loadData(widget.categoryId, "category");
    }
    setState(() {
      firstLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.queryString == null &&
              (Services.isAdmin() || Services.isSuperAdmin() || Services.isProductsController())
          ? FloatingActionButton(
              backgroundColor: ColorUtils.kmColors2,
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new AddProductsView(
                      categoryId: widget.categoryId,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Transform.scale(
                        scale: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Image.asset(
                            "assets/logobw.png",
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
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
                ? searchLoading || firstLoading
                    ? FacebookLoader()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(errorMessage, style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk)),
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
                                    ? _loadData(searchController.text, "search")
                                    : _loadData(widget.categoryId, "category");
                                // start loading data

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
                                return new GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => _onTileClicked(index),
                                  child: ProductsViewCard(
                                    subWarehouseId: eachProduct.subWarehouseId,
                                    productData: eachProduct,
                                    supplierCode: eachProduct.supplierCode,
                                    productId: eachProduct.id.toString(),
                                    active: int.parse(eachProduct.isActive),
                                    img: eachProduct.images.length > 0
                                        ? LoadingScreenServices.imagePrefixUrl +
                                            eachProduct.images[0].imageFileName
                                        : "",
                                    productName: eachProduct.name,
                                    quantity: eachProduct.unit.toString() != "null"
                                        ? eachProduct.quantity.toString() + " " + eachProduct.unit.toString()
                                        : eachProduct.quantity.toString(),
                                    price: int.parse(eachProduct.price.split(".")[0]),
                                    index: index,
                                  ),
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
                            child: theEndOfProducts
                                ? Text(
                                    "تم جلب جميع المنتجات",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    ),
                                  )
                                : Loader(),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  void _onTileClicked(int index) {
    ProductData productsDic = productsList[index];

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ProductDetailView(
          product: productsDic,
          isFromFavoriteScreen: false,
        ),
      ),
    );
  }
}

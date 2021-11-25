import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/funny_images.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/facebook_loader.dart';
import 'package:kammun_app/views/Wedgit/products_view_card.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_view/add_products.dart';

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
  TextEditingController _searchController = TextEditingController();

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
    Tools.logToConsole(
        "******************** => " + page.toString() + "the CatId : " + query);
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
          Tools.logToConsole("------ response status code -----");
          Tools.logToConsole(response.statusCode);
          if (response.statusCode == SUCCESS_CODE) {
            if (!response.data["success"] &&
                response.data["reason"] == "No results") {
              setState(() {
                searchLoading = false;
                if (firstLoading == true) firstLoading = false;
                isLoading = false;
                if (productsList.length != 0) {
                  theEndOfProducts = true;
                }
              });
            } else {
              final products =
                  categoryProductFromJson(jsonEncode(response.data));
              Tools.logToConsole("----- LENGTH : ${products.data.data.length}");
              //productsList.addAll(products.data.data);
              Tools.logToConsole("---------- warehouse -----------");
              productsList.addAll(products.data.data);

              Tools.logToConsole("Done Loading");
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
            Tools.logToConsole("------ the error code is 503 --------");
            setState(() {
              errorMessage =
                  "حدث خطأ أثناء محاولة جلب البيانات \n يرجى التحقق من إتصالك بالأنترنت";
              isLoading = false;
              searchLoading = false;
              firstLoading = false;
            });
          }
        } catch (e) {
          Tools.logToConsole("------- error catched ---------");
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
    // Add listeners to this class
    if (widget.queryString != null) {
      _loadData(widget.queryString, "search");
      _searchController.text = widget.queryString;
    } else {
      _loadData(widget.categoryId, "category");
    }
    setState(() {
      firstLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _showSearchTxtFld() {
      final GestureDetector searchButtonWithGesture = new GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Container(
            height: 40.0,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(6.0))),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) {
                setState(() {
                  // searchLoading = true;
                  productsList.clear();
                  // _loadData(_searchController.text, "search");
                  Navigator.of(context).pop();

                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new ProductsView(
                                queryString: _searchController.text,
                                categoryId: "0",
                              )));
                });
              },
              cursorColor: UtilsImporter().colorUtils.primarycolor,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding: const EdgeInsets.only(bottom: 0.5),
                hintText: "بحث",
                hintStyle: TextStyle(
                  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                ),
              ),
            ),
          ),
        ),
      );

      return new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
          child: searchButtonWithGesture);
    }

// Color.fromARGB(255, 210, 178, 2) كموني
//Color.fromARGB(255, 53, 99, 124) كجلي
    return Scaffold(
        floatingActionButton: widget.queryString == null
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddProductsView(
                                categoryId: widget.categoryId,
                              )));
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
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/cart', (Route<dynamic> route) => false);
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
                                ))),
                      ]),
                  _showSearchTxtFld(),
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
                ))
              : productsList.length == 0
                  ? searchLoading || firstLoading
                      ? FacebookLoader()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(errorMessage,
                                style: TextStyle(
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk)),
                          ),
                        )
                  : Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 10, right: 15, bottom: 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!isLoading &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    setState(() {
                                      page++;
                                      isLoading = true;
                                    });
                                    _searchController.text != ""
                                        ? _loadData(
                                            _searchController.text, "search")
                                        : _loadData(
                                            widget.categoryId, "category");
                                    // start loading data

                                  }
                                  return;
                                },
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: productsList == null
                                      ? 0
                                      : productsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var eachProduct = productsList[index];
                                    Tools.logToConsole(
                                        "--------- image length -------- $index ");
                                    Tools.logToConsole(
                                        eachProduct.images.length);
                                    return new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => _onTileClicked(index),
                                      child: ProductsViewCard(
                                        subWarehouseId:
                                            eachProduct.subWarehouseId,
                                        productData: eachProduct,
                                        supplierCode: eachProduct.supplierCode,
                                        productId: eachProduct.id.toString(),
                                        active: int.parse(eachProduct.isActive),
                                        img: eachProduct.images.length > 0
                                            ? LoadingScreenServices
                                                    .imagePrefixUrl +
                                                eachProduct
                                                    .images[0].imageFileName
                                            : "",
                                        productName: eachProduct.name,
                                        quantity: eachProduct.unit.toString() !=
                                                "null"
                                            ? eachProduct.quantity.toString() +
                                                " " +
                                                eachProduct.unit.toString()
                                            : eachProduct.quantity.toString(),
                                        price: int.parse(
                                            eachProduct.price.split(".")[0]),
                                        index: index,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: isLoading ? 50.0 : 0,
                              color: Colors.transparent,
                              child: Center(
                                child: theEndOfProducts
                                    ? Text("تم جلب جميع المنتجات",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: UtilsImporter()
                                                .stringUtils
                                                .HKGrotesk))
                                    : Loader(),
                              ),
                            ),
                          ])),
        ));
  }

  // Function to be called on click
  void _onTileClicked(int index) {
    Tools.logToConsole("You tapped on item $index");

    ProductData productsDic = productsList[index];

    // Services.userVisitProduct(productsDic.id.toString());

    //Second

    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new Second()));

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new ProductDetailView(
                  products: productsDic,
                  isFromFavoriteScreen: false,
                )));

    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => new ProductDetailView(
    //             heroIndex: index + 100, products: productsDic)));
  }
}

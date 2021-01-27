import 'dart:convert';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/api/api_URLs.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/core/api/api_provider.dart';
import 'package:kammun_app/core/errors/error_types.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/funny_images.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/facebook_loader.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import '../../Services.dart';

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
  bool theEndOfProducs = false;
  String errorMessage = "لم يتم العثور على المنتج";

  final _random = new Random();

  bool badWordmatched = false;

  Future<bool> _loadData(String query, String type) async {
    Tools.logToConsole(
        "******************** => " + page.toString() + "the CatId : " + query);
    setState(() {
      badWordmatched = false;
    });
    String url = "";
    if (badWord.contains(query)) {
      setState(() {
        badWordmatched = true;
      });
    }
    if (!badWordmatched) {
      if (type == "search") {
        url = "/api/product/search/$query?page=" + page.toString();
      } else {
        url = "/api/category/$query?page=$page";
      }

      if (!theEndOfProducs) {
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
                  theEndOfProducs = true;
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
                    theEndOfProducs = true;
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
          child: badWordmatched
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
                                        productId: eachProduct.id.toString(),
                                        active: int.parse(eachProduct.isActive),
                                        img: eachProduct.images.length > 0
                                            ? LoadingScreenServices
                                                    .imagePrefixUrl +
                                                eachProduct
                                                    .images[0].imageFileName
                                            : "",
                                        product_name: eachProduct.name,
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
                                child: theEndOfProducs
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

    Services.userVisitProduct(productsDic.id.toString());

    //Second

    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new Second()));

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new ProductDetailView(
                  heroIndex: index + 100,
                  products: productsDic,
                  isFromFavoraiteScreen: false,
                )));

    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => new ProductDetailView(
    //             heroIndex: index + 100, products: productsDic)));
  }
}

class ProductsViewCard extends StatefulWidget {
  final String img;
  final String product_name;
  final String quantity;
  final int price;
  final int index;
  int active;
  final String productId;

  ProductsViewCard(
      {this.img,
      this.product_name,
      this.quantity,
      this.price,
      this.index,
      this.productId,
      this.active});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  bool addedToCart = false;

  Future<bool> updateStatus(String productId, String statusId) async {
    Map jsonData = {
      // 'name': widget.productName,
      // 'quantity': widget.quantity,
      // 'is_featured': widget.isFeatured,
      // 'priority': widget.priority,
      // 'price': widget.price,
      // 'unit': widget.unit,
      // 'is_in_facebook': widget.isInfacebook,
      // 'description': widget.description,
      // 'category_id': widget.categoryId,
      'is_active': statusId,
    };

    var response = await ApiProvider.sendRequest(
      url: GET_PRODUCT + "$productId",
      method: httpMethods.put,
      body: jsonEncode(jsonData),
    );

    Tools.logToConsole(response.data);

    if (response.statusCode == SUCCESS_CODE && response.data["success"]) {
      Flushbar(
        backgroundColor: Colors.green,
        // titleText: Text("تمت الإضافة بنجاح"),
        messageText: Text(
          "تم التعديل بنجاح",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk),
        ),

        boxShadows: [
          BoxShadow(
            color: UtilsImporter().colorUtils.primarycolor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.assignment_turned_in,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      return true;
    } else {
      Flushbar(
        backgroundColor: Colors.red[900],
        messageText: Text(
          "فشل في العملية يرجى المحاولة من جديد",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk),
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.red,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.close,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(Radius.circular(20.0))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                          tag: widget.index + 100,
                          child: FadeInImage.assetNetwork(
                            fadeInCurve: Curves.fastOutSlowIn,
                            placeholder: "assets/kmIcon.png",
                            fit: BoxFit.contain,
                            image: widget.img,
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                          ))),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Text(
                                widget.product_name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.quantity,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: UtilsImporter().colorUtils.greycolor,
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                              UtilsImporter()
                                      .stringUtils
                                      .oCcy
                                      .format(widget.price)
                                      .toString() +
                                  " ${LoadingScreenServices.companyInformation.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //                 <--- border radius here
                          ),
                      border: Border.all(
                          color: UtilsImporter().colorUtils.primarycolor,
                          width: 2)),
                  child: Center(
                    child: Column(
                      children: [
                        Switch(
                          value: widget.active == 1 ? true : false,
                          onChanged: (value) {
                            if (widget.active == 1) {
                              updateStatus(widget.productId, "0");
                            } else {
                              updateStatus(widget.productId, "1");
                            }
                            setState(() {
                              if (widget.active == 1) {
                                widget.active = 0;
                              } else {
                                widget.active = 1;
                              }
                            });
                          },
                          activeTrackColor:
                              UtilsImporter().colorUtils.kmColors2,
                          activeColor: UtilsImporter().colorUtils.kmColors,
                        ),
                      ],
                    ),
                  ),
                ),

                // widget.active == 0
                //     ? Badge(
                //         borderRadius: BorderRadius.zero,
                //         shape: BadgeShape.square,
                //         badgeColor: UtilsImporter().colorUtils.primarycolor,
                //         badgeContent: Padding(
                //           padding: const EdgeInsets.only(
                //             right: 10.0,
                //           ),
                //           child: Column(
                //             children: [
                //               Text(
                //                 'نفذ من',
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: 15,

                //                     //fontWeight: FontWeight.w500,
                //                     fontFamily:
                //                         UtilsImporter().stringUtils.HKGrotesk),
                //               ),
                //               Text(
                //                 'المستودعات',
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: 15,
                //                     //   fontWeight: FontWeight.w500,
                //                     fontFamily:
                //                         UtilsImporter().stringUtils.HKGrotesk),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     : Container(),
              ],
            ),
          ],
        ),
        // SizedBox(height: 4),
        //  Divider()
      ),
    );
  }
}

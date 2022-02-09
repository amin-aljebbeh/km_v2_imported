import 'dart:convert';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/funny_images.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
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
  bool theEndOfProducts = false;
  String errorMessage = "لم يتم العثور على المنتج";

  final _random = new Random();

  bool badWordMatched = false;

  _loadData(String query, String type) async {
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
        url = API + PRODUCT + SEARCH + "$query?page=" + page.toString();
      } else {
        url = API + CATEGORY + "/$query?page=$page";
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
        } catch (e) {}
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
            decoration:
                new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) {
                if (_searchController.text.length > 0) {
                  setState(
                    () {
                      productsList.clear();
                      Navigator.of(context).pop();

                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new ProductsView(
                            queryString: _searchController.text,
                            categoryId: "0",
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              cursorColor: ColorUtils.primaryColor,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding: const EdgeInsets.only(bottom: 0.5),
                hintText: "بحث",
                hintStyle: TextStyle(
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                ),
              ),
            ),
          ),
        ),
      );

      return new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0), child: searchButtonWithGesture);
    }

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
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
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
                                _searchController.text != ""
                                    ? _loadData(_searchController.text, "search")
                                    : _loadData(widget.categoryId, "category");
                                return;
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
                          height: isLoading ? 50.0 : 0,
                          color: Colors.transparent,
                          child: Center(
                            child: theEndOfProducts
                                ? Text("تم جلب جميع المنتجات",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontFamily: StringUtils.fontFamilyHKGrotesk))
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

    Services.userVisitProduct(productsDic.id.toString());

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ProductDetailView(
          heroIndex: index + 100,
          products: productsDic,
          isFromFavoriteScreen: false,
        ),
      ),
    );
  }
}

//TODO
class ProductsViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int index;
  final int active;

  ProductsViewCard({this.img, this.productName, this.quantity, this.price, this.index, this.active});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  bool addedToCart = false;

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
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(borderRadius: new BorderRadius.all(Radius.circular(20.0))),
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
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Text(
                                widget.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.quantity,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.greyColor,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                              StringUtils().oCcy.format(widget.price).toString() +
                                  " ${LoadingScreenServices.companyInformation.currency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.primaryColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )),
                widget.active == 0
                    ? Badge(
                        borderRadius: BorderRadius.zero,
                        shape: BadgeShape.square,
                        badgeColor: ColorUtils.primaryColor,
                        badgeContent: Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'نفذ من',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk),
                              ),
                              Text(
                                'المستودعات',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    //   fontWeight: FontWeight.w500,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

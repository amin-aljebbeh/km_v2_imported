import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/views/Wedgit/favorite_products_view_card.dart';
import 'package:kammun_app/views/favorites/services/product_favorites_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class Favorites extends StatefulWidget {
  //int heroIndex;
  //String category_name;
  //List<Map<String, dynamic>> productsAry = [];

  //Favoraites({this.productsAry, this.category_name});

  @override
  State<StatefulWidget> createState() {
    return FavoritesViewState();
  }
}

class FavoritesViewState extends State<Favorites> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();

  _shareApp() {
    String infoMessage =
        "تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n";
    String androidGrating = "\n لتحميل التطبيق على الأندوريد \n";

    String androidUrl = androidGrating + LoadingScreenServices.iOSShareUrl;
    String iosGrating = "\n لتحميل التطبيق على الآيفون \n";
    String iPhoneUrl = iosGrating + LoadingScreenServices.androidShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  _openUrl(String selected) async {
    String url = "";
    if (selected == "whatsapp") {
      url = 'whatsapp://send?phone=' +
          LoadingScreenServices.companyInformation.whatsappNumber;
    } else if (selected == "messenger") {
      url = LoadingScreenServices.companyInformation.messengerUrl;
    } else if (selected == "facebook") {
      url = "fb://page/" +
          LoadingScreenServices.companyInformation.facebookUrl.toString();
    } else if (selected == "instagram") {
      url = LoadingScreenServices.companyInformation.instagramUrl.toString();
    } else if (selected == "website") {
      url = LoadingScreenServices.companyInformation.websiteUrl.toString();
    } else if (selected == "email") {
      String platform = "Android";
      if (Platform.isIOS) {
        platform = "iPhone";
      }
      url =
          "mailto:${LoadingScreenServices.companyInformation.email}?subject=Support Request From $platform Application&body=";
    } else if (selected == "number") {
      url = "tel:${LoadingScreenServices.supportPhoneNumber}";
    }

    launch(url);
  }

  int page = 1;
  bool productLoaded = true;
  bool theEndOfFavorites = false;
  bool isLoading = false;
  bool errorMessage = false;

  String errorMessageValue;

  List<ProductData> favoritesProductData = new List<ProductData>();

  _getFavorites() async {
    setState(() {
      FavoraitesProductsServices.lastPageNumber = page;
      if (page == 1) productLoaded = false;
      if (!theEndOfFavorites) isLoading = true;
      errorMessage = false;
    });

    final productList =
        await FavoraitesProductsServices.getUserFavoraites(pageNumber: page);
    if (productList != null) {
      if (productList.data == null) {
        setState(() {
          // LoadingScreenServices.userFavoriteProducts = productList.data;
          Tools.logToConsole("---- the last page ---");
          theEndOfFavorites = true;
          FavoraitesProductsServices.theEndOfFavoraites = true;
          productLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          favoritesProductData.addAll(productList.data);
          LoadingScreenServices.userFavoriteProducts = favoritesProductData;
          productLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        productLoaded = true;
        errorMessage = true;
        isLoading = false;
        errorMessageValue = "حدث خطأ أثناء محاولة جلب المفضلة";
      });
    }
  }

  Future getFavorites;

  @override
  void initState() {
    if (FavoraitesProductsServices.lastPageNumber == 1) {
      getFavorites = _getFavorites();
    } else {
      favoritesProductData = LoadingScreenServices.userFavoriteProducts;
    }
    page = FavoraitesProductsServices.lastPageNumber;
    theEndOfFavorites = FavoraitesProductsServices.theEndOfFavoraites;
    super.initState();
  }

  void _onTileClicked(int index) {
    Tools.logToConsole("You tapped on item $index");

    // Product productsDic = LoadingScreenServices.userFavoriteProducts[index];

    // SearchProductsList productToSend = new SearchProductsList();
    // productToSend.name = productsDic.name;
    // //productToSend.price = productsDic.price;
    // // productToSend.images = productsDic.images;
    // productToSend.description = productsDic.description;
    // productToSend.id = productsDic.id;
    // //productToSend.quantity = productsDic.quantity;
    // productToSend.unit = productsDic.unit;
    // //productToSend.isActive = productsDic.isActive;

    Tools.logToConsole("You tapped on item $index");

    ProductData productsDic = favoritesProductData[index];

    // Services.userVisitProduct(productsDic.id.toString());

    //Second

    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new Second()));

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new ProductDetailView(
                  product: productsDic,
                  isFromFavoriteScreen: true,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ProductsView(
                              queryString: _searchController.text,
                              categoryId: "0",
                            )));
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
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
          child: searchButtonWithGesture);
    }

    return Scaffold(
      drawer: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Drawer(
              child: Container(
                color: Colors.white,
                child: ListView(
                  primary: false,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 60,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: ColorUtils.kmColors)),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  //color: Colors.white,
                                  color: ColorUtils.kmColors,
                                ),
                              ),
                            ),
                          ),
                          // decoration: BoxDecoration(
                          //   color: ColorUtils.primarycolor,
                          // ),
                        ),
                      ),
                    ),
                    Container(
                        child: Image.asset(
                          //  "assets/logobw.png",
                          "assets/kmlogoo.png",
                          width: 250,
                          height: 200,
                        ),

                        //color: ColorUtils.kmColors,
                        color: Colors.white),
                    Divider(
                      color: ColorUtils.kmColors,
                      // height: 20,
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.phone,
                          color: ColorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "الإتصال بكمون",
                        style: mainStyle,
                      ),
                      onTap: () => _openUrl("number"),
                    ),
                    InkWell(
                      // onTap: _sendEmailToKammun,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.share,
                            color: ColorUtils.kmColors,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          "إرسال التطبيق للأصدقاء",
                          style: mainStyle,
                        ),
                        // subtitle: Text(
                        //   //'support@kammun.com',
                        //   "بدعمكم نستمر",

                        //   style: TextStyle(
                        //       fontFamily: StringUtils.HKGrotesk,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        onTap: () => _shareApp(),
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.info_outline,
                          color: ColorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "الملف الشخصي",
                        style: mainStyle,
                      ),
                      // subtitle: Text(
                      //   // 'www.kammun.com',
                      //   LoadingScreenServices
                      //       .companyInformation.websiteUrl,

                      //   style: TextStyle(
                      //       fontFamily: StringUtils.HKGrotesk,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                    ),
                    Divider(
                      color: ColorUtils.kmColors,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _openUrl("facebook"),
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: ColorUtils.primaryColor,
                                size: 30,
                              ),
                            ),
                            InkWell(
                              onTap: () => _openUrl("instagram"),
                              child: Icon(
                                FontAwesomeIcons.instagram,
                                color: ColorUtils.primaryColor,
                                size: 30,
                              ),
                            ),
                            InkWell(
                              onTap: () => _openUrl("messenger"),
                              child: Icon(
                                FontAwesomeIcons.facebookMessenger,
                                color: ColorUtils.primaryColor,
                                size: 30,
                              ),
                            ),
                            InkWell(
                              onTap: () => _openUrl("whatsapp"),
                              child: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: ColorUtils.primaryColor,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
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
                          padding: const EdgeInsets.only(top: 12.0),
                          child: InkWell(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 40,
                            ),
                          )),
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
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LoadingScreenServices.userFavoriteProducts.length > 0
                  ? Expanded(
                      child: NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!isLoading &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            Tools.logToConsole("in List");
                            setState(() {
                              page++;
                            });
                            !theEndOfFavorites
                                ? _getFavorites()
                                : Tools.logToConsole('');
                          }
                          return;
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: favoritesProductData == null
                              ? 0
                              : favoritesProductData.length,
                          itemBuilder: (BuildContext context, int index) {
                            var eachProduct = favoritesProductData[index];

                            return new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => _onTileClicked(index),
                              child: FavoriteProductsViewCard(
                                active: int.parse(eachProduct.isActive),
                                img: eachProduct.images.length > 0
                                    ? LoadingScreenServices.imagePrefixUrl +
                                        eachProduct.images[0].imageFileName
                                    : "",
                                productName: eachProduct.name,
                                quantity: eachProduct.unit.toString() != "null"
                                    ? eachProduct.quantity.toString() +
                                        " " +
                                        eachProduct.unit.toString()
                                    : eachProduct.quantity.toString(),
                                price:
                                    int.parse(eachProduct.price.split(".")[0]),
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.3),
                        child: Center(
                          child: Text(
                            !isLoading ? "لم تقم بإضافة أي عنصر للمفضلة" : "",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.greyColor,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
              theEndOfFavorites && favoritesProductData.length != 0
                  ? Container(
                      height: 50.0,
                      color: Colors.transparent,
                      child: Center(
                          child: Text("تم جلب جميع المنتجات",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      StringUtils.fontFamilyHKGrotesk))))
                  : Container(),
              isLoading
                  ? Container(
                      height: 50.0,
                      color: Colors.transparent,
                      child: Center(
                        child: Loader(),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

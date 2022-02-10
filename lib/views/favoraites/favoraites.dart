import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/favoraites/services/product_favoraites_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_view/products_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Services.dart';

class Favoraites extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoraitesViewState();
  }
}

class FavoraitesViewState extends State<Favoraites> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();

  _shareApp() {
    String infoMessage = "تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n";
    String androidGrating = "\n لتحميل التطبيق على الأندوريد \n";

    String androidUrl = androidGrating + LoadingScreenServices.iOSShareUrl;
    String iosGrating = "\n لتحميل التطبيق على الآيفون \n";
    String iPhoneUrl = iosGrating + LoadingScreenServices.androidShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  _openUrl(String selected) async {
    String url = "";
    if (selected == "whatsapp") {
      url = 'whatsapp://send?phone=' + LoadingScreenServices.supportPhoneNumber.toString();
    } else if (selected == "messenger") {
      url = LoadingScreenServices.companyInformation.messengerUrl;
    } else if (selected == "facebook") {
      if (Platform.isIOS) {
        url = 'fb://profile/${LoadingScreenServices.companyInformation.facebookUrl.toString()}';
      } else {
        url = 'fb://page/${LoadingScreenServices.companyInformation.facebookUrl.toString()}';
      }
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
      url = "tel:${LoadingScreenServices.supportPhoneNumber.toString()}";
    }

    launch(url, forceSafariVC: false);
  }

  int page = 1;
  bool productLoaded = true;
  bool theEndOfFavoraites = false;
  bool isLoading = false;
  bool errorMessage = false;

  String errorMessageValue;

  List<ProductData> favoraitesProductData = new List<ProductData>();
  _getFavoraites() async {
    setState(() {
      FavoraitesProductsServices.lastPageNumber = page;
      if (page == 1) productLoaded = false;
      if (!theEndOfFavoraites) isLoading = true;
      errorMessage = false;
    });

    final productList = await FavoraitesProductsServices.getUserFavoraites(pageNumber: page);
    if (productList != null) {
      if (productList.data == null) {
        setState(() {
          theEndOfFavoraites = true;
          FavoraitesProductsServices.theEndOfFavoraites = true;
          productLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          favoraitesProductData.addAll(productList.data);
          LoadingScreenServices.userFavoriteProducts = favoraitesProductData;
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

  Future getFavoraites;

  @override
  void initState() {
    if (FavoraitesProductsServices.lastPageNumber == 1) {
      getFavoraites = _getFavoraites();
    } else {
      favoraitesProductData = LoadingScreenServices.userFavoriteProducts;
    }
    page = FavoraitesProductsServices.lastPageNumber;
    theEndOfFavoraites = FavoraitesProductsServices.theEndOfFavoraites;
    super.initState();
  }

  void _onTileClicked(int index) {
    ProductData productsDic = favoraitesProductData[index];

    Services.userVisitProduct(productsDic.id.toString());

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ProductDetailView(
          heroIndex: index + 100,
          product: productsDic,
          isFromFavoriteScreen: true,
        ),
      ),
    );
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
            decoration:
                new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(6.0))),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) {
                if (_searchController.text.length > 0) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new ProductsView(
                        queryString: _searchController.text,
                        categoryId: "0",
                      ),
                    ),
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
                          decoration:
                              BoxDecoration(color: Colors.white, border: Border.all(color: ColorUtils.kmColors)),
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
                        ),
                      ),
                    ),
                    Container(
                        child: Image.asset(
                          "assets/kmlogoo.png",
                          width: 250,
                          height: 200,
                        ),
                        color: Colors.white),
                    Divider(
                      color: ColorUtils.kmColors,
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
                        style: TextStyle(
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                        ),
                      ),
                      onTap: () => _openUrl("number"),
                    ),
                    InkWell(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.share,
                            color: ColorUtils.kmColors,
                            size: 30,
                          ),
                        ),
                        title: Text("إرسال التطبيق للأصدقاء",
                            style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk)),
                        onTap: () => _shareApp(),
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.person,
                          color: ColorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                      title: Text("الملف الشخصي", style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk)),
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.policy,
                          color: ColorUtils.kmColors,
                          size: 30,
                        ),
                      ),
                      title:
                          Text("سياسة الإستخدام", style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk)),
                      onTap: () {
                        launch('http://kammun.com/privacy-policy.html', enableJavaScript: false);
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
                          Navigator.of(context).pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                  ],
                ),
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
                          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            setState(() {
                              page++;
                            });
                            !theEndOfFavoraites ? _getFavoraites() : Tools.logToConsole('do no thing');
                          }
                          return true;
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: favoraitesProductData == null ? 0 : favoraitesProductData.length,
                          itemBuilder: (BuildContext context, int index) {
                            var eachProduct = favoraitesProductData[index];

                            return ProductsViewCard(
                              id: eachProduct.id.toString(),
                              product: eachProduct,
                              active: int.parse(eachProduct.isActive),
                              img: eachProduct.images.length > 0
                                  ? LoadingScreenServices.imagePrefixUrl + eachProduct.images[0].imageFileName
                                  : "",
                              productName: eachProduct.name,
                              quantity: eachProduct.unit.toString() != "null"
                                  ? eachProduct.quantity.toString() + " " + eachProduct.unit.toString()
                                  : eachProduct.quantity.toString(),
                              price: int.parse(eachProduct.price.split(".")[0]),
                              index: index,
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
              theEndOfFavoraites && favoraitesProductData.length != 0
                  ? Container(
                      height: 50.0,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "تم جلب جميع المنتجات",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontFamily: StringUtils.fontFamilyHKGrotesk),
                        ),
                      ),
                    )
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

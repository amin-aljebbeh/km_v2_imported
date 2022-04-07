import 'package:flutter/material.dart';
import 'package:kammun_app/models/products_categories_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/favoraites/services/product_favoraites_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';

class Favoraites extends StatefulWidget {
  const Favoraites({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FavoraitesViewState();
  }
}

class FavoraitesViewState extends State<Favoraites> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  int page = 1;
  bool productLoaded = true;
  bool theEndOfFavoraites = false;
  bool isLoading = false;
  bool errorMessage = false;

  String errorMessageValue;

  List<ProductData> favoraitesProductData = [];
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

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const KDrawer(),
      key: scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 210, 178, 2),
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
                            scaffoldKey.currentState.openDrawer();
                          },
                          child: const Icon(
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
                        icon: const Icon(
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
                StoreSearchTextField(
                    scaffoldKey: scaffoldKey, searchController: searchController, onSubmit: () {}),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(105.0),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LoadingScreenServices.userFavoriteProducts.isNotEmpty
                  ? Expanded(
                      child: NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            setState(() {
                              page++;
                            });
                            !theEndOfFavoraites ? _getFavoraites() : Tools.logToConsole('');
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
                              product: eachProduct,
                              index: index,
                            );
                          },
                        ),
                      ),
                    )
                  : Padding(
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
              theEndOfFavoraites && favoraitesProductData.isNotEmpty
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
                      child: const Center(
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

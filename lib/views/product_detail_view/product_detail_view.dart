import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';

class ProductDetailView extends StatefulWidget {
  final ProductData product;

  ProductDetailView({
    this.product,
  });

  @override
  State<StatefulWidget> createState() {
    return ProductDetailViewState();
  }
}

class ProductDetailViewState extends State<ProductDetailView> {
  bool favoriteProduct;
  List<Widget> images = [];
  ValueNotifier<Size> size = ValueNotifier<Size>(Size(0, 0));
  getImages() {
    if (widget.product.images.isNotEmpty) {
      images.addAll(widget.product.images
          .map((image) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    image: DecorationImage(
                      image: AdvImageCache(
                        LoadingScreenServices.imagePrefixUrl + image.imageFileName,
                        useMemCache: true,
                        diskCacheExpire: Duration(seconds: 0),
                      ),
                    )),
              ))
          .toList());
    } else {
      images.add(Image.asset("assets/logobw.png"));
    }
  }

  int numberOfOrders = 1;

  @override
  void initState() {
    super.initState();
    favoriteProduct =
        LoadingScreenServices.userFavoriteProducts.any((productId) => productId.id == widget.product.id);
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      iconSize: 35,
                      icon: const Icon(Icons.home),
                      tooltip: 'Back to Store Page',
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 35,
                        ),
                      ),
                    ],
                    backgroundColor: ColorUtils.kmColors,
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    title: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        widget.product.name,
                        maxLines: 1,
                        style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
                      ),
                    ),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          FlexibleSpaceBar(
                            centerTitle: true,
                            background: widget.product.images.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 40, left: 5, right: 5, bottom: 10),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                                      child: new Carousel(
                                        onImageTap: (index) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return FullScreenImage(
                                                  imageUrl: LoadingScreenServices.imagePrefixUrl +
                                                      widget.product.images[index].imageFileName,
                                                  tag: "generate_a_unique_tag",
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        dotColor: ColorUtils.kmColors,
                                        dotIncreasedColor: ColorUtils.kmColors,
                                        dotBgColor: Colors.transparent,
                                        borderRadius: true,
                                        boxFit: BoxFit.cover,
                                        images: images,
                                        autoplay: true,
                                        animationCurve: Curves.fastLinearToSlowEaseIn,
                                        animationDuration: Duration(milliseconds: 1000),
                                        dotSize: 6.0,
                                        indicatorBgPadding: 8.0,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    "assets/logobw.png",
                                  ),
                          ),
                          Positioned(
                            top: 40,
                            right: 3,
                            child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  favoriteProduct ? Icons.favorite : Icons.favorite_border_outlined,
                                  color: Colors.red[900],
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    favoriteProduct = !favoriteProduct;
                                  });
                                  _addToFavoriteBtnTapped(context);
                                  if (favoriteProduct) {
                                    Flushbar(
                                      backgroundColor: Colors.red[900],
                                      messageText: Text(
                                        " تم إضافة ${widget.product.name}  إلى المفضلة",
                                        style: flushBarStyle,
                                      ),
                                      boxShadows: [
                                        BoxShadow(
                                          color: Colors.red,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        )
                                      ],
                                      icon: Icon(
                                        Icons.favorite,
                                        size: 28.0,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else {
                                    Flushbar(
                                      backgroundColor: Colors.red[900],
                                      messageText: Text(
                                        "تم إزالة ${widget.product.name}  من المفضلة",
                                        style: flushBarStyle,
                                      ),
                                      boxShadows: [
                                        BoxShadow(
                                          color: Colors.red,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        )
                                      ],
                                      icon: Icon(
                                        Icons.favorite,
                                        size: 28.0,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 22,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("الكمية",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.primaryColor,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 20.0,
                                    )),
                                SizedBox(height: 10),
                                Text(
                                  widget.product.unit.toString() != "null"
                                      ? widget.product.quantity.toString() + " " + widget.product.unit.toString()
                                      : widget.product.quantity.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.primaryColor,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("السعر",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.greyColor,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 20.0,
                                    )),
                                SizedBox(height: 10),
                                Text(
                                    "${StringUtils().oCcy.format(int.parse(widget.product.price.toString().split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.primaryColor,
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 20)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.product.description.split("@")[0],
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(35.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      numberOfOrders.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 30,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '(${StringUtils().oCcy.format(numberOfOrders * int.parse(widget.product.price.toString().split(".")[0]))})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          KammunButton(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Divider(
                                              color: Colors.white,
                                              height: 1,
                                              thickness: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        String productsId = "";
                                        String productsQuantity = "";
                                        if (LoadingScreen.userToken.length > 5) {
                                          Navigator.of(context).pop(true);

                                          widget.product.productCount = numberOfOrders;

                                          CartServices.addProductToCart(widget.product);
                                          Flushbar(
                                            backgroundColor: Colors.green,
                                            messageText: Text(
                                              "تم إضافة ${widget.product.name} لسلة المشتريات",
                                              style: flushBarStyle,
                                            ),
                                            boxShadows: [
                                              BoxShadow(
                                                color: ColorUtils.primaryColor,
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
                                            leftBarIndicatorColor: ColorUtils.kmColors,
                                          )..show(context);

                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          productsId = CartServices.cartProducts
                                              .fold('', (ids, product) => product.id.toString() + ';');
                                          productsQuantity = CartServices.cartProducts.fold(
                                              '', (counts, product) => product.productCount.toString() + ';');
                                          prefs.setString("userCart", productsId + "@" + productsQuantity);
                                        } else {
                                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                                        }
                                      },
                                      child: AutoSizeText(
                                        StringUtils.addToCart,
                                        style: decisionButtonStyle,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Divider(
                                              color: Colors.white,
                                              height: 1,
                                              thickness: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: -3,
                                  bottom: 10,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove_rounded,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (numberOfOrders > 1) {
                                          numberOfOrders = numberOfOrders - 1;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  bottom: 10,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        numberOfOrders = numberOfOrders + 1;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            height: 50,
                            color: ColorUtils.kmColors,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToFavoriteBtnTapped(context) {
    if (LoadingScreen.userToken.length > 5) {
      favoriteProduct ? _addFavorite(context, widget.product) : _removeFavorite();
    } else {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
  }

  void _addFavorite(BuildContext ctx, ProductData product) {
    Services.addToFavorites(widget.product.id.toString());
    LoadingScreenServices.userFavoriteProducts.add(product);
  }

  void _removeFavorite() {
    LoadingScreenServices.userFavoriteProducts.removeWhere((product) => product.id == widget.product.id);
    Services.removeFromFavorites(widget.product.id.toString());
  }
}

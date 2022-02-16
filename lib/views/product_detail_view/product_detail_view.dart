import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:full_screen_image/full_screen_image.dart';

// ignore: must_be_immutable
class ProductDetailView extends StatefulWidget {
  ProductData product;
  bool isFromFavoriteScreen;

  ProductDetailView({this.product, @required this.isFromFavoriteScreen});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailViewState();
  }
}

class ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool done = false;
  bool favoriteProduct;

  final _controller = ScrollController(initialScrollOffset: 0.0);
  final _height = 100.0;

  int numberOfOrders = 1;

  @override
  void initState() {
    super.initState();
    favoriteProduct =
        LoadingScreenServices.userFavoriteProducts.any((productId) => productId.id == widget.product.id);
    Timer(Duration(milliseconds: 100), () => _animateToIndex(2.5));

    _animationController = new AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween(begin: 1.5, end: 0.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _animateToIndex(i) async {
    await _controller.animateTo(
      _height * i,
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );
    setState(() {
      done = true;
    });
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
              controller: _controller,
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
                    backgroundColor: ColorUtils.primaryColor,
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    title: Container(
                      alignment: Alignment.bottomCenter,
                      child: done
                          ? AutoSizeText(
                              widget.product.name,
                              maxLines: 1,
                              style: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk),
                            )
                          : Container(),
                    ),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        background: !done
                            ? FullScreenWidget(
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: FadeTransition(
                                    opacity: _animation,
                                    child: widget.product.images.length > 0
                                        ? Image.network(
                                            LoadingScreenServices.imagePrefixUrl +
                                                widget.product.images[0].imageFileName,
                                            width: MediaQuery.of(context).size.width / 2,
                                            height: 120,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            "assets/logobw.png",
                                          ),
                                  ),
                                ),
                              )
                            : widget.product.images.length > 0
                                ? FullScreenWidget(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        LoadingScreenServices.imagePrefixUrl +
                                            widget.product.images[0].imageFileName,
                                        width: MediaQuery.of(context).size.width / 2,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    "assets/logobw.png",
                                  ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            IconButton(
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
                          ],
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
                        SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              numberOfOrders.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              color: Colors.white,
              height: 65,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: KammunButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (numberOfOrders > 1) {
                                        numberOfOrders = numberOfOrders - 1;
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/remove.png",
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Divider(
                                      color: ColorUtils.searchGreyColor,
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AutoSizeText(
                              '${StringUtils.addToCart}  (${StringUtils().oCcy.format(numberOfOrders * int.parse(widget.product.price.toString().split(".")[0]))})',
                              style: decisionButtonStyle,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Divider(
                                      color: ColorUtils.searchGreyColor,
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      numberOfOrders = numberOfOrders + 1;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/add.png",
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        height: 50,
                        color: Theme.of(context).primaryColor,
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
                            productsId =
                                CartServices.cartProducts.fold('', (ids, product) => product.id.toString() + ';');
                            productsQuantity = CartServices.cartProducts
                                .fold('', (counts, product) => product.productCount.toString() + ';');
                            prefs.setString("userCart", productsId + "@" + productsQuantity);
                          } else {
                            Navigator.of(context).pushNamed(LoginScreen.routeName);
                          }
                        },
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

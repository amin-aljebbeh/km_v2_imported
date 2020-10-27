import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/Loading.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:full_screen_image/full_screen_image.dart';

class ProductDetailView extends StatefulWidget {
  int heroIndex;
  ProductsData products;
  bool isFromFavoraiteScreen;

  ProductDetailView(
      {this.heroIndex, this.products, @required this.isFromFavoraiteScreen});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailViewState();
  }
}

class ProductDetailViewState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool done = false;

  final _controller = ScrollController(initialScrollOffset: 0.0);
  final _height = 100.0;

  int no_of_orders = 1;
  int price = 0;
  bool productOnFavoraites = false;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 100), () => _animateToIndex(2.5));

    _animationController = new AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween(begin: 1.5, end: 0.0).animate(_animationController);

    //  CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
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

  // curve: Curves.linear, duration: Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    print("------ the image length --------");
    print(widget.products.images.length);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        //backgroundColor: UtilsImporter().colorUtils.primarycolor,
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
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false),
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
                backgroundColor: UtilsImporter().colorUtils.primarycolor,
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                title: Container(
                  alignment: Alignment.bottomCenter,
                  //padding: EdgeInsets.only(top: 15),
                  //   width: MediaQuery.of(context).size.width * 0.65,
                  child: done
                      ? AutoSizeText(
                          widget.products.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk),
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
                                child: widget.products.images.length > 0
                                    ? Image.network(
                                        LoadingScreenServices.imagePrefixUrl +
                                            widget.products.images[0]
                                                .imageFileName,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        "assets/logobw.png",
                                      ),
                              ),
                            ),
                          )
                        : widget.products.images.length > 0
                            ? FullScreenWidget(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    LoadingScreenServices.imagePrefixUrl +
                                        widget.products.images[0].imageFileName,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
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
              padding: EdgeInsets.only(left: 20, right: 20, top: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.products.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 22,
                          )),
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
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 20.0,
                                )),
                            SizedBox(height: 10),
                            Text(
                              widget.products.unit.toString() != "null"
                                  ? widget.products.quantity.toString() +
                                      " " +
                                      widget.products.unit.toString()
                                  : widget.products.quantity.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
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
                                  color: UtilsImporter().colorUtils.greycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 20.0,
                                )),
                            SizedBox(height: 10),
                            Text(
                                "${UtilsImporter().stringUtils.oCcy.format(int.parse(widget.products.warehouses[0].pivot.price.toString().split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "الوصف",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: UtilsImporter().colorUtils.greycolor,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.products.description.split("@")[0],
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    int.parse(widget.products.warehouses[0].pivot.isActive) != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (no_of_orders > 1) {
                                        no_of_orders = no_of_orders - 1;
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/remove.png",
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(no_of_orders.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 30)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      no_of_orders = no_of_orders + 1;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/add.png",
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                        10.0) //                 <--- border radius here
                                    ),
                                border: Border.all(
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    width: 4)),
                            child: Center(
                                child: Text(
                              "المنتج نفذ من المستودعات",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk),
                            )),
                          ),
                    int.parse(widget.products.warehouses[0].pivot.isActive) != 0
                        ? SizedBox(height: 30)
                        : Container(),
                    int.parse(widget.products.warehouses[0].pivot.isActive) != 0
                        ? _showAddToOrderButton(context)
                        : Container(),
                    Builder(builder: (context) => _showAddToFavorait(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showAddToOrderButton(BuildContext ctx) {
    final GestureDetector addAddToOrderButtonWithGesture = new GestureDetector(
      onTap: () async {
        String products_Id = "";
        String products_quantity = "";
        if (LoadingScreen.user_token.length > 5) {
          Navigator.of(context).pop(true);

          // ProductsData productToAdd = new ProductsData();
          // List<Warehouse> warehouses = new List<Warehouse>();
          // Pivot pivot = new Pivot();
          // pivot.price = widget.products.warehouses[0].pivot.price;
          // warehouses[0].pivot = pivot;
          // productToAdd.warehouses = warehouses;

          // productToAdd.id = widget.products.id;
          // productToAdd.name = widget.products.name;
          // productToAdd.quantity = widget.products.quantity;
          // // productToAdd.warehouses[0].pivot.price =
          // //     widget.products.warehouses[0].pivot.price;
          // productToAdd.unit = widget.products.unit;
          // productToAdd.productCount = no_of_orders;
          // productToAdd.images = widget.products.images;

          print("========= product price ========");

          print(widget.products.warehouses[0].pivot.price);
          widget.products.productCount = no_of_orders;

          CartServices.addProductToCart(widget.products);

          // Toast.show("تم إضافة ${productToAdd.name} لسلة المشتريات", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

          Flushbar(
            backgroundColor: Colors.green,
            // titleText: Text("تمت الإضافة بنجاح"),
            messageText: Text(
              "تم إضافة ${widget.products.name} لسلة المشتريات",
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

          SharedPreferences prefs = await SharedPreferences.getInstance();
          for (int i = 0; i < CartServices.cartProducts.length; i++) {
            products_Id += CartServices.cartProducts[i].id.toString() + ";";
            products_quantity +=
                CartServices.cartProducts[i].productCount.toString() + ";";
          }
          // products_Id += widget.products.id.toString();
          // products_quantity += widget.products.quantity.toString();
          prefs.setString("userCart", products_Id + "@" + products_quantity);

          // CartServices.save("cart", Services.cartProducts);
        } else {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        }
      },
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            'الإضافة لسلة المشتريات  ( ${UtilsImporter().stringUtils.oCcy.format(no_of_orders * int.parse(widget.products.warehouses[0].pivot.price.toString().split(".")[0]))})',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
        child: addAddToOrderButtonWithGesture);
  }

  Widget _showAddToFavorait(BuildContext ctx) {
    final GestureDetector addAddToOrderButtonWithGesture = new GestureDetector(
      onTap: () {
        _addToFavoraitBtnTapped(ctx);
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.red[800],
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            LoadingScreenServices.userFavoriteProducts
                        .where(
                          (productId) => productId.id == widget.products.id,
                        )
                        .length ==
                    1
                ? 'الإزالة من المفضلة'
                : 'الإضافة إلى المفضلة',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding:
            EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 20.0),
        child: addAddToOrderButtonWithGesture);
  }

  void _addToFavoraitBtnTapped(context) {
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text("Item Addes"),
    // ));
    if (LoadingScreen.user_token.length > 5) {
      LoadingScreenServices.userFavoriteProducts
                  .where(
                    (productId) => productId.id == widget.products.id,
                  )
                  .length ==
              0
          ? _addFavoraite(context)
          : _removeFavoraite();
      if (widget.isFromFavoraiteScreen) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/favoraites', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
  }

  void _addFavoraite(BuildContext ctx) {
    // Services.addToFavorites(widget.products.id.toString());
    print("im in add to favoraitses");
    //Navigator.of(context).pop();

    Flushbar(
      messageText: Text(
        " تم إضافة ${widget.products.name}  إلى المفضلة",
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
        Icons.favorite,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
    )..show(context);
  }

  void _removeFavoraite() {
    for (int i = 0; i < LoadingScreenServices.userFavoriteProducts.length; i++)
      if (LoadingScreenServices.userFavoriteProducts[i].id ==
          widget.products.id)
        LoadingScreenServices.userFavoriteProducts.removeAt(i);

    Services.removeFromFavorites(widget.products.id.toString());

    // Toast.show("تم إزالة ${widget.products.name}  من المفضلة", context,
    //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    Flushbar(
      //  backgroundColor: UtilsImporter().colorUtils.kmColors,
      message: "تم إزالة ${widget.products.name}  من المفضلة",

      icon: Icon(
        Icons.favorite,
        size: 28.0,
        color: Colors.redAccent,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }
}

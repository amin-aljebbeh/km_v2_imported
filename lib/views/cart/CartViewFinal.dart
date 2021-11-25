import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/orders_response.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/decision_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/thank_you/thank_you_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'order_problem_sheet.dart';

class CartViewFinal extends StatefulWidget {
  static String message = "";

  @override
  State<StatefulWidget> createState() {
    return _CartViewFinalState();
  }
}

class _CartViewFinalState extends State<CartViewFinal> {
  List<ProductData> orderArray;
  int subtotal = 0;
  int deliveryCost = 10;
  List<int> cards = [];
  bool loadingScreen = false;
  bool errorCode = false;
  String errorMessage = "يرجى المحاولة مرة أخرى و التأكد من إتصالك بالإنترنت";

  int total = 0;
  TextEditingController _userNotes = TextEditingController();
  TextEditingController _copouns = TextEditingController();

  makeCards() {
    cards = [];
    for (int i = 0; i < orderArray.length; i++) {
      cards.add(i);
    }
    Tools.logToConsole("Orders Length ${orderArray.length}");
  }

  _reloadPrices() async {
    Navigator.of(context).pop();

    setState(() {
      loadingScreen = true;
    });

    CartServices.cartProducts.clear();
    await CartServices.getUserCart();
    setState(() {
      loadingScreen = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/cartFinal');
  }

  @override
  void initState() {
    orderArray = CartServices.cartProducts;
    makeCards();

    for (int i = 0; i < orderArray.length; i++) {
      subtotal = subtotal +
          ((int.parse(orderArray[i].price.split(".")[0])) *
              orderArray[i].productCount);
    }
    total = subtotal +
        Services.deliveryPrice +
        int.parse(LoadingScreenServices
            .myOrdersList[OrderServices.orderUnderUpdateIndex].deliveryCost
            .split(".")[0]);

    // total = subtotal + Services.delivery_Price;

    OrderServices.updateOrderNote != null
        ? WidgetsBinding.instance
            .addPostFrameCallback((_) => _userNotesInitial())
        : print('');

    super.initState();
  }

  void onrRemove(item) {
    setState(() {
      cards.removeAt(item);
      CartViewState.cards.removeAt(item);

      if (cards.length == 0) {
        KammunRestart.restartApp(context);
      }
    });
  }

  _userNotesInitial() {
    _userNotes.text = OrderServices.updateOrderNote;

    // if (CartServices.userNote != null) {
    //   _userNotes.text = CartServices.userNote;
    // }
    if (CartServices.userCopoun != null) {
      _copouns.text = CartServices.userCopoun;
    }
    // if (CartServices.userNote == null) {
    //   _userNotes.text = OrderServices.updateOrderNote;
    // }

    // _userNotes.text = LoadingScreenServices
    //     .myOrdersList[OrderServices.orderUnderUpdateIndex].userNotes;

    // if (CartServices.userNote != null) {
    //   _userNotes.text = CartServices.userNote;
    // }
    // if (CartServices.userCopoun != null) {
    //   _copouns.text = CartServices.userCopoun;
    // }
  }

  _cartChanged() async {
    String productsId = "";
    String productsQuantity = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ";";
      productsQuantity +=
          CartServices.cartProducts[i].productCount.toString() + ";";
    }
    // productsId += widget.products.id.toString();
    // productsQuantity += widget.products.quantity.toString();
    prefs.setString("userCart", productsId + "@" + productsQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
        child: SafeArea(
          child: loadingScreen
              ? Center(
                  child: Loader(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    errorCode
                        ? AlertMessages(
                            text: " $errorMessage",
                            messageType: "internetError",
                            headerText: " حدث خطأ اثناء محاولة إرسال طلبك",
                          )
                        : Container(
                            padding: EdgeInsets.zero,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Theme.of(context).primaryColorDark,
                                size: 45,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop("updatePrice");
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop("updatePrice");
                            },
                            child: Text(
                              UtilsImporter().stringUtils.shoppingCart,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: orderArray == null ? 0 : cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          Tools.logToConsole("Build Card Length : $index");
                          return new GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => _onTileClicked(index),
                            child: Container(
                              //  color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 0, right: 0, top: 0),
                                child: cardBody(index, context),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          UtilsImporter().stringUtils.subtotal,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                            fontSize: 17.0,
                          ),
                        ),
                        Text(
                          "${UtilsImporter().stringUtils.oCcy.format(subtotal)} ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 17.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(UtilsImporter().stringUtils.delivery,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 16.0,
                            )),
                        Text(
                          "${UtilsImporter().stringUtils.oCcy.format(int.parse(LoadingScreenServices.myOrdersList[OrderServices.orderUnderUpdateIndex].deliveryCost.split(".")[0]) + int.parse(LoadingScreenServices.myOrdersList[OrderServices.orderUnderUpdateIndex].supportedCityCost.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(UtilsImporter().stringUtils.total,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 19.0,
                            )),
                        Text(
                          "${UtilsImporter().stringUtils.oCcy.format(total)} ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              fontSize: 19),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SafeArea(
                      child: loadingScreen
                          ? Loader()
                          : Column(
                              children: <Widget>[
                                DecisionButton(
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                top: 0, bottom: 0, right: 15),
                                            child: Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: Text(
                                              'إضافة ملاحظة',
                                              textAlign: TextAlign.start,
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  // fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: UtilsImporter()
                                                      .stringUtils
                                                      .HKGrotesk),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // padding: EdgeInsets.only(top: 7, bottom: 7, right: 5),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.transparent,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    showMyDialog(
                                      ' ',
                                      ' ',
                                      null,
                                      Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Positioned(
                                            right: -40.0,
                                            top: -40.0,
                                            child: InkResponse(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                child: Icon(Icons.close),
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "ملاحظات على الطلب",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily:
                                                          UtilsImporter()
                                                              .stringUtils
                                                              .HKGrotesk,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            5.0) //         <--- border radius here
                                                        ),
                                                    border: Border.all(
                                                      width: 2,
                                                      color: UtilsImporter()
                                                          .colorUtils
                                                          .kmColors,
                                                    )),
                                                child: new TextField(
                                                  controller: _userNotes,
                                                  textAlign: TextAlign.right,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: 5,
                                                  style: TextStyle(
                                                    fontFamily: UtilsImporter()
                                                        .stringUtils
                                                        .HKGrotesk,
                                                  ),
                                                ),
                                              ),
                                              DecisionButton(
                                                text: "حفظ الملاحظة",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                height: 40,
                                                color: UtilsImporter()
                                                    .colorUtils
                                                    .primarycolor,
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      context,
                                    );
                                  },
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: <Widget>[
                                //     _addNotesButton(context: context),
                                //     //    _addCopouns(),
                                //   ],
                                // ),
                                DecisionButton(
                                  width: MediaQuery.of(context).size.width,
                                  color: CartServices.cartProducts.length > 0
                                      ? UtilsImporter().colorUtils.primarycolor
                                      : Colors.grey[400],
                                  text: UtilsImporter()
                                      .stringUtils
                                      .confirmOrder
                                      .toUpperCase(),
                                  onTap: _showConfirmOrderBtnTapped,
                                  height: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                )
                                // _showConfirmOrderButton(),
                              ],
                            ),
                      top: false,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget cardBody(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                width: 75.0,
                height: 75.0,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Hero(
                        tag: index + 100,
                        child: Image(
                            image: orderArray[index].images.length != 0
                                ? AdvImageCache(
                                    LoadingScreenServices.imagePrefixUrl +
                                        orderArray[index]
                                            .images[0]
                                            .imageFileName
                                            .toString(),
                                    useMemCache: true,
                                    diskCacheExpire: Duration(days: 400),
                                  )
                                : AssetImage("assets/kmIcon.png"),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            // fadeInCurve: Curves.fastOutSlowIn,
                            // placeholder: AssetImage("assets/kmIcon.png"),
                            fit: BoxFit.contain))),
              ),
              //SizedBox(width: 10),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              orderArray[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18),
                            ),
                            SizedBox(height: 6),
                            Text(
                              orderArray[index].quantity.toString() +
                                  " " +
                                  orderArray[index].unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: UtilsImporter().colorUtils.greycolor,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8),
                            Text(
                                "${UtilsImporter().stringUtils.oCcy.format(int.parse(orderArray[index].price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        UtilsImporter().colorUtils.primarycolor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UtilsImporter()
                            .colorUtils
                            .greycolor
                            .withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          orderArray[index].productCount += 1;
                          subtotal += (int.parse(
                              orderArray[index].price.split(".")[0]));

                          total += (int.parse(
                              orderArray[index].price.split(".")[0]));
                        });
                        _cartChanged();
                      },
                      child: Image.asset(
                        "assets/add.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(orderArray[index].productCount.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 18)),
                  SizedBox(height: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UtilsImporter()
                            .colorUtils
                            .greycolor
                            .withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (orderArray[index].productCount > 1) {
                            subtotal -= (int.parse(
                                orderArray[index].price.split(".")[0]));
                            orderArray[index].productCount =
                                orderArray[index].productCount - 1;

                            total -= (int.parse(
                                orderArray[index].price.split(".")[0]));
                          } else if (orderArray[index].productCount == 1) {
                            subtotal -= (int.parse(
                                orderArray[index].price.split(".")[0]));

                            total -= (int.parse(
                                orderArray[index].price.split(".")[0]));
                            onrRemove(index);
                            CartServices.cartProducts.removeAt(index);
                          }
                        });
                        _cartChanged();
                      },
                      child: Image.asset(
                        "assets/remove.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Divider(
            thickness: 3,
          )
        ],
      ),
    );
  }

  // Function to be called on click
  void _onTileClicked(int index) {
    Tools.logToConsole("You tapped on item $index");
    // Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) =>
    //             new ProductDetailView(heroIndex: index + 100)));
  }

  _showBottomSheet({List<String> notActive, List<String> priceProblem}) {
    List<int> notActiveId = [];
    List<int> priceId = [];

    for (int i = 0; i < orderArray.length; i++) {
      if (notActive.contains(orderArray[i].id.toString())) {
        notActiveId.add(orderArray[i].id);
      }
      if (priceProblem.contains(orderArray[i].id.toString())) {
        priceId.add(orderArray[i].id);
      }
    }
    Tools.logToConsole("------ price array ---------");
    Tools.logToConsole(priceId);
    Tools.logToConsole("-------- inactive array --------");
    Tools.logToConsole(notActiveId);
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => OrderProblemBottomSheet(
        notActiveProducts: notActiveId,
        pricesChangesProducts: priceId,
        applyChanges: (submitOrder) {
          if (submitOrder) {
            _showConfirmOrderBtnTapped(checkOrderPrice: false);
          } else {
            _reloadPrices();
          }
        },
      ),
    );
  }

  void _showConfirmOrderBtnTapped({bool checkOrderPrice = true}) async {
    setState(() {
      loadingScreen = true;
      errorCode = false;
    });
    CartServices.userNote = _userNotes.text;
    CartServices.userCopoun = _copouns.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    OrderResponse orderResponse;
    if (OrderServices.orderUnderUpdateIndex != -1) {
      Tools.logToConsole("updating Order");
      orderResponse = await OrderServices.updateOrder(
          userNotes: _userNotes.text, checkPrices: checkOrderPrice);

      setState(() {
        try {
          if (orderResponse != null) {
            if (!orderResponse.success &&
                orderResponse.reason.contains("discontinued")) {
              loadingScreen = false;
              errorCode = true;
              errorMessage =
                  "نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل";
            } else if (orderResponse.changedPriceProducts.length > 0 ||
                orderResponse.inactiveProducts.length > 0) {
              _showBottomSheet(
                  notActive: orderResponse.inactiveProducts,
                  priceProblem: orderResponse.changedPriceProducts);

              loadingScreen = false;
              errorCode = false;
            } else if (orderResponse.success) {
              CartViewFinal.message = orderResponse.data;
              // CartServices.cartProducts.clear();
              prefs.setString("orderUnderUpdateId", "-1");
              OrderServices.orderUnderUpdateIndex = -1;
            } else if (!orderResponse.success) {
              loadingScreen = false;
              errorCode = true;
            }
          } else {
            LoadingScreenServices
                .myOrdersList[OrderServices.orderUnderUpdateIndex]
                .underUpdate = '0';
            // OrderServices.unlockOrder(LoadingScreenServices
            //     .myOrdersList[OrderServices.orderUnderUpdateIndex].id
            //     .toString());
            loadingScreen = false;
            errorCode = true;
          }
        } catch (e) {
          loadingScreen = false;
          errorCode = true;
        }
      });
    } else {
      orderResponse = await OrderServices.submitNewOrder(
          userNotes: _userNotes.text, checkPrices: checkOrderPrice);

      setState(() {
        try {
          if (orderResponse != null) {
            if (!orderResponse.success &&
                orderResponse.reason.contains("discontinued")) {
              loadingScreen = false;
              errorCode = true;
              errorMessage =
                  "نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل";
            } else if (orderResponse.changedPriceProducts.length > 0 ||
                orderResponse.inactiveProducts.length > 0) {
              _showBottomSheet(
                  notActive: orderResponse.inactiveProducts,
                  priceProblem: orderResponse.changedPriceProducts);

              loadingScreen = false;
              errorCode = false;
            } else if (orderResponse.success) {
              Tools.logToConsole("orderData is :");
              Tools.logToConsole(orderResponse.data.toString());
              CartViewFinal.message = orderResponse.data;
              // CartServices.cartProducts.clear();
            }
          } else {
            loadingScreen = false;
            errorCode = true;
          }
        } catch (e) {
          loadingScreen = false;
          errorCode = true;
          Tools.logToConsole(e.toString());
          Tools.logToConsole("I'm in catch");
        }
      });
    }

    if (orderResponse.success == true) {
      await prefs.remove("userCart");
      CartServices.cartProducts.clear();

      CartServices.userNote = "";
      CartServices.userCopoun = "";

      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  ThankYouView(orderMessage: orderResponse.data)));
    }
  }
}

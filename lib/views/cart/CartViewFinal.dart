import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/orders_response.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/cart/cart_view.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/deliver_to/deliver_to_view.dart';
import 'package:kammun_app/views/deliver_to/delivery_method.dart';
import 'package:kammun_app/views/deliver_to/services/delivery_method_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/thank_you/thank_you_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      subtotal = subtotal + ((int.parse(orderArray[i].price.split(".")[0])) * orderArray[i].productCount);
    }

    total = subtotal +
        LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice +
        int.parse(DeliveryMethodServices.deliveryMethodsList[DeliveryMethodView.selectedDeliveryIndex].pivot.price
            .split(".")[0]);

    OrderServices.updateOrderNote != null && OrderServices.orderUnderUpdateIndex != -1
        ? WidgetsBinding.instance.addPostFrameCallback((_) => _userNotesInitial())
        : Tools.logToConsole('');

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

    if (CartServices.userCopoun != null) {
      _copouns.text = CartServices.userCopoun;
    }
    if (_userNotes.text == "null") {
      _userNotes.text = "";
    }
  }

  _cartChanged() async {
    String productsId = "";
    String productsQuantity = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ";";
      productsQuantity += CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", productsId + "@" + productsQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: loadingScreen
              ? Center(
                  child: Loader(),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
                  child: Column(
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
                                  icon: Icon(Icons.arrow_back_ios,
                                      color: Theme.of(context).primaryColorDark, size: 45),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                StringUtils.shoppingCart,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                            return Container(
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                                child: cardBody(index, context),
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
                            StringUtils.subtotal,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 17.0,
                            ),
                          ),
                          Text(
                            "${StringUtils().oCcy.format(subtotal)} ${LoadingScreenServices.companyInformation.currency}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 17.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(StringUtils.delivery,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 16.0,
                              )),
                          Text(
                            "${StringUtils().oCcy.format(LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice + int.parse(DeliveryMethodServices.deliveryMethodsList[DeliveryMethodView.selectedDeliveryIndex].pivot.price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(StringUtils.total,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 19.0,
                              )),
                          Text(
                            "${StringUtils().oCcy.format(total)} ${LoadingScreenServices.companyInformation.currency}",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 19),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SafeArea(
                        child: loadingScreen
                            ? Loader()
                            : Column(
                                children: [
                                  _addNotesButton(context: context),
                                  _showConfirmOrderButton(),
                                ],
                              ),
                        top: false,
                      ),
                    ],
                  ),
                ),
        ));
  }

  _openAddNotesAlert({BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ملاحظات على الطلب",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0) //         <--- border radius here
                              ),
                          border: Border.all(
                            width: 2,
                            color: ColorUtils.kmColors,
                          )),
                      child: TextField(
                        controller: _userNotes,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        style: TextStyle(
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                        ),
                      ),
                    ),
                    _saveNotes(context: context),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget cardBody(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 75.0,
                height: 75.0,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Hero(
                        tag: index + 100,
                        child: FadeInImage(
                            image: orderArray[index].images.length != 0
                                ? NetworkImage(LoadingScreenServices.imagePrefixUrl +
                                    orderArray[index].images[0].imageFileName.toString())
                                : AssetImage("assets/kmIcon.png"),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            fadeInCurve: Curves.fastOutSlowIn,
                            placeholder: AssetImage("assets/kmIcon.png"),
                            fit: BoxFit.contain))),
              ),
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
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 18),
                            ),
                            SizedBox(height: 6),
                            Text(
                              orderArray[index].quantity.toString() + " " + orderArray[index].unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8),
                            Text(
                                "${StringUtils().oCcy.format(int.parse(orderArray[index].price.split(".")[0]))} ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: ColorUtils.greyColor.withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          orderArray[index].productCount += 1;
                          subtotal += (int.parse(orderArray[index].price.split(".")[0]));

                          total += (int.parse(orderArray[index].price.split(".")[0]));
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
                          fontFamily: StringUtils.fontFamilyHKGrotesk,
                          fontSize: 18)),
                  SizedBox(height: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: ColorUtils.greyColor.withOpacity(0.2)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (orderArray[index].productCount > 1) {
                            subtotal -= (int.parse(orderArray[index].price.split(".")[0]));
                            orderArray[index].productCount = orderArray[index].productCount - 1;

                            total -= (int.parse(orderArray[index].price.split(".")[0]));
                          } else if (orderArray[index].productCount == 1) {
                            subtotal -= (int.parse(orderArray[index].price.split(".")[0]));

                            total -= (int.parse(orderArray[index].price.split(".")[0]));
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

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => OrderProblemBottomSheet(
        notActiveProducts: notActiveId,
        pricesChangesProducts: priceId,
        applyChanges: () {
          _reloadPrices();
        },
      ),
    );
  }

  void _showConfirmOrderBtnTapped() async {
    setState(() {
      loadingScreen = true;
      errorCode = false;
    });
    CartServices.userNote = _userNotes.text;
    CartServices.userCopoun = _copouns.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    OrderResponse orderResponse;
    if (OrderServices.orderUnderUpdateIndex != -1) {
      if (cards.length == 0) {
        KammunRestart.restartApp(context);
      } else {
        orderResponse = await OrderServices.updateOrder(userNotes: _userNotes.text);

        setState(() {
          try {
            if (orderResponse != null) {
              if (!orderResponse.success && orderResponse.reason.contains("discontinued")) {
                loadingScreen = false;
                errorCode = true;
                errorMessage =
                    "نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل";
              } else if (orderResponse.changedPriceProducts.length > 0 ||
                  orderResponse.inactiveProducts.length > 0) {
                _showBottomSheet(
                    notActive: orderResponse.inactiveProducts, priceProblem: orderResponse.changedPriceProducts);

                loadingScreen = false;
                errorCode = false;
              } else if (orderResponse.success) {
                CartViewFinal.message = orderResponse.data;
                prefs.setString("orderUnderUpdateId", "-1");
                OrderServices.orderUnderUpdateIndex = -1;
              } else if (!orderResponse.success) {
                loadingScreen = false;
                errorCode = true;
              }
            } else {
              loadingScreen = false;
              errorCode = true;
            }
          } catch (e) {
            loadingScreen = false;
            errorCode = true;
          }
        });
      }
    } else {
      if (cards.length == 0) {
        KammunRestart.restartApp(context);
      } else {
        orderResponse = await OrderServices.submitNewOrder(userNotes: _userNotes.text);
        setState(() {
          try {
            if (orderResponse != null) {
              if (!orderResponse.success && orderResponse.reason.contains("discontinued")) {
                loadingScreen = false;
                errorCode = true;
                errorMessage =
                    "نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل";
              } else if (orderResponse.changedPriceProducts.length > 0 ||
                  orderResponse.inactiveProducts.length > 0) {
                _showBottomSheet(
                    notActive: orderResponse.inactiveProducts, priceProblem: orderResponse.changedPriceProducts);

                loadingScreen = false;
                errorCode = false;
              } else if (orderResponse.success) {
                CartViewFinal.message = orderResponse.data;
              }
            } else {
              loadingScreen = false;
              errorCode = true;
            }
          } catch (e) {
            loadingScreen = false;
            errorCode = true;
          }
        });
      }
    }

    if (orderResponse != null) {
      if (orderResponse.success == true) {
        await prefs.remove("userCart");
        CartServices.cartProducts.clear();

        CartServices.userNote = "";
        CartServices.userCopoun = "";

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ThankYouView(orderMessage: orderResponse.data)));
      }
    }
  }

  Widget _showConfirmOrderButton() {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: _showConfirmOrderBtnTapped,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 50.0,
          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Center(
            child: Text(
              StringUtils.confirmOrder,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: StringUtils.fontFamilyHKGrotesk),
            ),
          ),
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0), child: showConfirmButtonWithGesture);
  }

  Widget _addNotesButton({BuildContext context}) {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () => _openAddNotesAlert(context: context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          //  padding: const EdgeInsets.all(10.0),
          //  width: MediaQuery.of(context).size.width / 2.5,
          height: 40.0,
          decoration:
              BoxDecoration(color: ColorUtils.primaryColor, borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 0, bottom: 0, right: 15),
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
                      style: TextStyle(
                          color: Colors.white,
                          // fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: StringUtils.fontFamilyHKGrotesk),
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
          )),
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0), child: showConfirmButtonWithGesture);
  }

  Widget _saveNotes({BuildContext context}) {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width / 2.5,
          height: 40.0,
          decoration:
              BoxDecoration(color: ColorUtils.primaryColor, borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Center(
            child: AutoSizeText(
              "حفظ الملاحظة",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  // fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: StringUtils.fontFamilyHKGrotesk),
            ),
          ),
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0), child: showConfirmButtonWithGesture);
  }
}

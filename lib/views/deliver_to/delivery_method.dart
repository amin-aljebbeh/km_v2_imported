import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/order_problem_sheet.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/thank_you/thank_you_view.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/cart/CartViewFinal.dart';
import 'package:kammun_app/views/deliver_to/services/delivery_method_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:group_button/group_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deliver_to_view.dart';

class DeliveryMethodView extends StatefulWidget {
  static int selectedDeliveryIndex = 0;

  @override
  _DeliveryMethodViewState createState() => _DeliveryMethodViewState();
}

class _DeliveryMethodViewState extends State<DeliveryMethodView> {
  int selectedIndex = 0;
  int deliveryCost = 0;
  Future getDeliveryMethods;
  List<int> cards = [];
  int subTotal = 0;
  List<ProductData> orderArray = [];
  int total = 0;
  bool isLoading = false;
  bool error;
  String errorMessage;

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
    _reloadPrices() async {
      Navigator.of(context).pop();

      setState(() {
        isLoading = true;
      });

      CartServices.cartProducts.clear();

      await CartServices.getUserCart();
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/cartFinal');
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

  makeCards() {
    cards = [];
    for (int i = 0; i < orderArray.length; i++) {
      cards.add(i);
    }
  }

  void _showConfirmOrderBtnTapped() async {
    setState(() {
      isLoading = true;
      error = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    OrderResponse orderResponse;
    if (OrderServices.orderUnderUpdateIndex != -1) {
      if (cards.length == 0) {
        KammunRestart.restartApp(context);
      } else {
        orderResponse = await OrderServices.updateOrder(userNotes: OrderServices.updateOrderNote);

        setState(() {
          try {
            if (orderResponse != null) {
              if (!orderResponse.success && orderResponse.reason.contains("discontinued")) {
                isLoading = false;
                error = true;
                errorMessage =
                    "نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل";
              } else if (orderResponse.changedPriceProducts.length > 0 ||
                  orderResponse.inactiveProducts.length > 0) {
                _showBottomSheet(
                    notActive: orderResponse.inactiveProducts, priceProblem: orderResponse.changedPriceProducts);

                isLoading = false;
                error = false;
              } else if (orderResponse.success) {
                CartViewFinal.message = orderResponse.data;
                prefs.setString("orderUnderUpdateId", "-1");
                OrderServices.orderUnderUpdateIndex = -1;
              } else if (!orderResponse.success) {
                isLoading = false;
                error = true;
              }
            } else {
              isLoading = false;
              error = true;
            }
          } catch (e) {
            isLoading = false;
            error = true;
          }
        });
      }
    } else {
      if (cards.length == 0) {
        KammunRestart.restartApp(context);
      } else {
        orderResponse = await OrderServices.submitNewOrder(userNotes: OrderServices.updateOrderNote);
        setState(() {
          try {
            if (orderResponse != null) {
              if (!orderResponse.success && orderResponse.reason.contains("discontinued")) {
                isLoading = false;
                error = true;
                errorMessage =
                    "نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل";
              } else if (orderResponse.changedPriceProducts.length > 0 ||
                  orderResponse.inactiveProducts.length > 0) {
                _showBottomSheet(
                    notActive: orderResponse.inactiveProducts, priceProblem: orderResponse.changedPriceProducts);

                isLoading = false;
                error = false;
              } else if (orderResponse.success) {
                CartViewFinal.message = orderResponse.data;
              }
            } else {
              isLoading = false;
              error = true;
            }
          } catch (e) {
            isLoading = false;
            error = true;
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

  @override
  void initState() {
    getDeliveryMethods = _getDeliveryMethods();
    orderArray = CartServices.cartProducts;
    makeCards();
    for (int i = 0; i < orderArray.length; i++) {
      subTotal = subTotal + ((int.parse(orderArray[i].price.split(".")[0])) * orderArray[i].productCount);
    }

    super.initState();
  }

  _getDeliveryMethods() async {
    setState(() {
      isLoading = true;
    });

    bool response = await DeliveryMethodServices.getUserDeliveryMethod(
        addressId: LoadingScreenServices.userAddress[DeliverToView.selectedIndex].id.toString());

    deliveryCost = LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice +
        int.parse(DeliveryMethodServices.deliveryMethodsList[DeliveryMethodView.selectedDeliveryIndex].pivot.price
            .split(".")[0]);
    selectedIndex = 0;
    total = subTotal +
        LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice +
        int.parse(DeliveryMethodServices.deliveryMethodsList[DeliveryMethodView.selectedDeliveryIndex].pivot.price
            .split(".")[0]);
    if (response != null && response) {
      setState(() {
        isLoading = false;
        error = false;
        errorMessage = "";
      });
    } else {
      setState(() {
        isLoading = false;
        error = true;
        errorMessage =
            "حدث خطأ أثناء محاولة جلب طرق التوصيل المتاحة يرجى التأكد من إتصالك بالإنترنت و المحاولة مجدداً";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: isLoading
            ? Center(child: Loader())
            : Padding(
                padding: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorDark, size: 45),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            StringUtils.deliverMethod,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    error
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                                child: AlertMessages(
                                  messageType: "internetError",
                                  headerText: "حدث خطأ",
                                  text: errorMessage,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0) //         <--- border radius here
                                            ),
                                        border: Border.all(
                                          width: 2,
                                          color: ColorUtils.kmColors,
                                        )),
                                    child: GroupButton(
                                      unselectedTextStyle: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk),
                                      selectedTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk),
                                      direction: Axis.vertical,
                                      isRadio: true,
                                      spacing: 10,
                                      onSelected: (index, isSelected) {
                                        setState(() {
                                          selectedIndex = index;
                                          DeliveryMethodView.selectedDeliveryIndex = index;
                                          deliveryCost = LoadingScreenServices
                                                  .userAddress[DeliverToView.selectedIndex].deliveryPrice +
                                              int.parse(DeliveryMethodServices
                                                  .deliveryMethodsList[DeliveryMethodView.selectedDeliveryIndex]
                                                  .pivot
                                                  .price
                                                  .split(".")[0]);
                                        });
                                      },
                                      buttons:
                                          DeliveryMethodServices.deliveryMethodsList.map((f) => f.name).toList(),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: AlertMessages(
                                      headerTextSize: 23,
                                      messageTextSize: 20,
                                      messageType: "Successfully",
                                      headerText: "شرح عن طريقة التوصيل",
                                      text:
                                          DeliveryMethodServices.deliveryMethodsList[selectedIndex].pivot.message,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  // padding: const EdgeInsets.all(8.0),
                                  child: Text("اجرةالتوصيل النهائية",
                                      style: TextStyle(
                                          color: ColorUtils.primaryColor,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk)),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                      "${int.parse(DeliveryMethodServices.deliveryMethodsList[selectedIndex].pivot.price.split(".")[0]) + LoadingScreenServices.userAddress[DeliverToView.selectedIndex].deliveryPrice} ${LoadingScreenServices.companyInformation.currency}",
                                      style: TextStyle(
                                          color: ColorUtils.primaryColor,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: StringUtils.fontFamilyHKGrotesk)),
                                ),
                              ],
                            ),
                          ),
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
                          "${StringUtils().oCcy.format(subTotal)} ${LoadingScreenServices.companyInformation.currency}",
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
                          "${StringUtils().oCcy.format(deliveryCost)} ${LoadingScreenServices.companyInformation.currency}",
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
                          "${StringUtils().oCcy.format(subTotal + deliveryCost)} ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 19),
                        ),
                      ],
                    ),
                    error
                        ? KammunButton(
                            color: ColorUtils.primaryColor,
                            onTap: () {
                              _getDeliveryMethods();
                            },
                            text: StringUtils.tryAgain,
                            height: 50,
                          )
                        : KammunButton(
                            color: ColorUtils.primaryColor,
                            onTap: () {
                              _showConfirmOrderBtnTapped();
                            },
                            height: 50,
                            text: StringUtils.confirmOrder,
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../../service.dart';
import 'package:intl/intl.dart';

import 'rating_view.dart';
import 'services/order_services.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrdersViewState();
  }
}

class OrdersViewState extends State<OrdersView> {
  Future getOrders;
  int rateValue;

  @override
  void initState() {
    rateValue = 0;
    getOrders = _getOrder();
    super.initState();
  }

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageValue = "";
  bool isLoading = false;
  int page = 1;
  bool theEndOfOrders = false;

  List<OrdersOriginalData> orderDataList = [];
  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
    });
    final orderList = await Services.getMyOrders(pageNumber: page);
    if (orderList != null) {
      if (orderList.isEmpty) {
        setState(() {
          LoadingScreenServices.myOrdersList = orderDataList;
          if (LoadingScreenServices.myOrdersList.isNotEmpty)
            theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            orderDataList.addAll(orderList);
            LoadingScreenServices.myOrdersList = orderDataList;
            orderLoaded = true;
            errorMessage = false;
            isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        orderLoaded = true;
        errorMessage = true;
        isLoading = false;
        errorMessageValue = "حدث خطأ اثناء محاولة جلب الطلبات";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 10),
              child: !orderLoaded
                  ? const Center(
                      child: Loader(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          errorMessage
                              ? AlertMessages(
                                  text: errorMessageValue,
                                  messageType: "internetError",
                                  headerText: "حدث خطأ",
                                )
                              : Container(
                                  padding: EdgeInsets.zero,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                StringUtils.yourOrders,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 30),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      page = 1;
                                      theEndOfOrders = false;
                                      orderDataList.clear();
                                      LoadingScreenServices.myOrdersList
                                          .clear();
                                    });
                                    _getOrder();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 40,
                                    color: ColorUtils.kmColors,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          orderDataList.isEmpty
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight * 0.4),
                                  child: Center(
                                    child: Text(
                                      "لا يوجد أي طلبات سابقة",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.greyColor,
                                        fontFamily:
                                            StringUtils.fontFamilyHKGrotesk,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.zero,
                                ),
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!isLoading &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  setState(() {
                                    page++;
                                  });
                                  !theEndOfOrders
                                      ? _getOrder()
                                      : Tools.logToConsole('');
                                  return true;
                                }
                                return false;
                              },
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                primary: false,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orderDataList == null
                                    ? 0
                                    : orderDataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String dateTime =
                                      DateFormat('kk:mm - yyyy-MM-dd').format(
                                          orderDataList[index].createdAt);
                                  return Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () => _onTileClicked(index),
                                        child: OrdersViewCard(
                                          underUpdate: int.parse(
                                              orderDataList[index].underUpdate),
                                          orderTitle: "",
                                          orderTotalPrice: orderDataList[index]
                                              .total
                                              .toString(),
                                          orderStatus: int.parse(
                                              orderDataList[index]
                                                  .orderStatusId),
                                          orderQuantity: orderDataList[index]
                                              .products
                                              .length,
                                          orderCreatedDate: dateTime,
                                        ),
                                      ),
                                      _showStartChatButton(index),
                                      int.parse(orderDataList[index]
                                                  .orderStatusId) ==
                                              1
                                          ? _showCancelButton(index)
                                          : Container(),
                                      (int.parse(orderDataList[index]
                                                      .orderStatusId) <
                                                  3) &&
                                              orderDataList[index]
                                                      .underUpdate ==
                                                  "0"
                                          ? _showEditButton(index)
                                          : Container(),
                                      int.parse(orderDataList[index]
                                                  .orderStatusId) ==
                                              5
                                          ? orderDataList[index]
                                                      .userDeliveryRating ==
                                                  null
                                              ? _showRatingButton(
                                                  context, index, screenHeight)
                                              : Container()
                                          : Container(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Divider(
                                          thickness: 5,
                                          color: ColorUtils.kmColors2,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          theEndOfOrders
                              ? Container(
                                  height: 50.0,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Text("تم جلب جميع الطلبات",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: StringUtils
                                                  .fontFamilyHKGrotesk))))
                              : Container(),
                          isLoading
                              ? Container(
                                  height: 50.0,
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Loader(),
                                  ),
                                )
                              : Container()
                        ])),
        ));
  }

  Widget _showViewChatButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(
            body: const VChatRoomsView(),
            appBar: AppBar(),
          ),
        ));
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            "view chats",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  Widget _showStartChatButton(int index) {
     String txt = "";
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("new message"),
              content: TextField(
                onChanged: (value) {
                  txt = value;
                },
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await VChatController.instance.createSingleChat(
                          peerEmail: "rabie",
                          message: txt,
                          context: context);
                    },
                    child: Text("send"))
              ],
            );
          },
        );
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            "Start chats",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  Widget _showCancelButton(int index) {
    bool isOrderUnderUpdate = false;
    if (orderDataList[index].underUpdate == "1") {
      isOrderUnderUpdate = true;
    }
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () async {
        setState(() {
          orderLoaded = false;
        });
        String x = await OrderServices.cancelOrderService(
            orderDataList[index].id.toString());
        if (x == "true") {
          setState(() {
            orderLoaded = true;
            errorMessage = false;
          });
          if (isOrderUnderUpdate) {
            orderDataList[index].underUpdate = "0";
            OrderServices.orderUnderUpdateIndex = -1;
          }
          Toast.show("تم إلغاء طلبك بنجاح", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          orderDataList[index].orderStatusId = "6";
        } else {
          setState(() {
            orderDataList[index].orderStatusId = "2";

            orderLoaded = true;
            errorMessage = true;

            errorMessageValue = x;
          });
          // Toast.show("حدثت مشكلة أثناء إلغاء الطلب يرجى تحديث لصفحة", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            StringUtils.cancelOrder,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  _moveOrderProductsToCart({int orderIndex}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartServices.cartProducts.clear();
    String productsId = "";
    String productsQuantity = "";

    for (int i = 0;
        i < LoadingScreenServices.myOrdersList[orderIndex].products.length;
        i++) {
      ProductData product = ProductData();

      product.id =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].id;
      product.images =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].images;
      product.name =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].name;

      product.price = LoadingScreenServices
          .myOrdersList[orderIndex].products[i].pivot.purchasePrice;

      // warehouses.pivot = warehousePivot;
      // listWarehouses.add(warehouses);
      //  product.warehouses = listWarehouses;
      // product. warehouses[0].pivot.price = LoadingScreenServices
      //     .myOrdersList[orderIndex].products[i].pivot.purchasePrice;
      product.productCount = int.parse(LoadingScreenServices
          .myOrdersList[orderIndex].products[i].pivot.quantity);
      product.unit =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].unit;
      product.quantity =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].quantity;

      CartServices.addProductToCart(product);
      // products_Id += widget.products.id.toString();
      // products_quantity += widget.products.quantity.toString();
    }

    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ";";
      productsQuantity +=
          CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", productsId + "@" + productsQuantity);

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cartFromUpdate',
      (Route<dynamic> route) => false,
    );
  }

  void _settingModalBottomSheet(context, int index, double screenHeight) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => RatingView(
        orderId: orderDataList[index].id.toString(),
        onRequestDone: () {
          orderDataList[index].userDeliveryRating = rateValue.toString();
          orderDataList.clear();

          _getOrder();
        },
      ),
    );
  }

  Widget _showRatingButton(
      BuildContext ctx, int orderIndex, double screenHeight) {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () => _settingModalBottomSheet(ctx, orderIndex, screenHeight),
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: ColorUtils.kmColors,
            borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            StringUtils.ratingOrder,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  Widget _showEditButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () async {
        setState(() {
          orderLoaded = false;
          errorMessage = false;
        });
        String x = await OrderServices.lockOrderService(
            orderDataList[index].id.toString());
        if (x != "null") {
          if (x == "true") {
            setState(() {
              orderLoaded = true;
              errorMessage = false;
            });
            _moveOrderProductsToCart(orderIndex: index);
            orderDataList[index].underUpdate = "1";
          } else if (x == "admin") {
            setState(() {
              orderDataList[index].underUpdate = "2";
              orderLoaded = true;
              errorMessage = true;
              errorMessageValue =
                  "لا يمكنك تعديل طلبك حالياً لأن مسؤول الطلب يقوم بتعديله حالياً";
            });
          } else if (x == "Another") {
            setState(() {
              orderDataList[index].underUpdate = "2";
              orderLoaded = true;
              errorMessage = true;
              errorMessageValue =
                  " لا يمكنك تعديل طلبك حالياً لأنه بالفعل لديك طلب آخر قيد التعديل يرجى الإنتهاء من تعديل الطلب السابق و المحاولة من جديد";
            });
          } else {
            setState(() {
              orderLoaded = true;
              errorMessage = true;
              errorMessageValue =
                  "لا يمكنك تعديل طلبك حالياً لانه تم الإنتهاء من تطبيق طلبك بنجاح";
            });
          }
        } else {
          setState(() {
            orderLoaded = true;
            errorMessage = true;
            errorMessageValue =
                "حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت";
          });
        }
      },
      child: Container(
        height: 40.0,
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            StringUtils.editOrder,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  void _onTileClicked(int index) {
    List<OrderProducts> ordAry = orderDataList[index].products;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetailView(
                  ordersAry: ordAry,
                  subTotal: int.parse(
                          orderDataList[index].total.toString().split(".")[0]) -
                      int.parse(orderDataList[index]
                          .supportedCityCost
                          .toString()
                          .split(".")[0]) -
                      int.parse(
                          orderDataList[index].deliveryCost.split(".")[0]),
                  total: orderDataList[index].total.toString(),
                  deliveryPrice: (int.parse(orderDataList[index]
                              .supportedCityCost
                              .split(".")[0]) +
                          int.parse(
                              orderDataList[index].deliveryCost.split(".")[0]))
                      .toString(),
                )));
  }
}

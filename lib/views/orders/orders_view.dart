import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../Services.dart';
import 'package:intl/intl.dart';

import 'services/order_services.dart';

class OrdersView extends StatefulWidget {
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
    // print("the Order list from Loading : ");
    // print(LoadingScreenServices.myOrdersList);
    // if (LoadingScreenServices.myOrdersList.length > 5) {
    //   LoadingScreenServices.myOrdersList
    //       .removeRange(5, LoadingScreenServices.myOrdersList.length);
    // }
    getOrders = _getOrder();

    //orderDataList = LoadingScreenServices.myOrdersList;
    super.initState();
  }

  FocusNode _focusNode = new FocusNode();
  TextEditingController _textFieldController = new TextEditingController();

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageVlue = "";
  bool isLoading = false;
  int page = 1;
  bool theEndOfOrders = false;

  List<OrdersOriginalData> orderDataList = new List<OrdersOriginalData>();
  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
    });
    final orderList = await Services.getMyOrders(pageNumber: page);
    if (orderList != null) {
      if (orderList.length == 0) {
        setState(() {
          LoadingScreenServices.myOrdersList = orderDataList;
          if (LoadingScreenServices.myOrdersList.length != 0)
            theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDataList.addAll(orderList);
          LoadingScreenServices.myOrdersList = orderDataList;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        orderLoaded = true;
        errorMessage = true;
        isLoading = false;
        errorMessageVlue = "حدث خطأ اثناء محاولة جلب الطلبات";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
              child: !orderLoaded
                  ? Center(
                      child: Loader(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          errorMessage
                              ? AlertMessages(
                                  text: errorMessageVlue,
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
                                UtilsImporter().stringUtils.your_orders,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
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
                                    color: UtilsImporter().colorUtils.kmColors,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          orderDataList.length == 0
                              ? Container(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: screenHight * 0.4),
                                    child: Center(
                                      child: Text(
                                        "لا يوجد أي طلبات سابقة",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: UtilsImporter()
                                              .colorUtils
                                              .greycolor,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk,
                                          fontSize: 20.0,
                                        ),
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
                                  print("in List");
                                  setState(() {
                                    page++;
                                  });
                                  !theEndOfOrders ? _getOrder() : {};
                                }
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
                                      new GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () => _onTileClicked(index),
                                        child: OrdersViewCard(
                                          underUpdate: int.parse(
                                              orderDataList[index].underUpdate),
                                          order_title: "",
                                          order_total_price:
                                              orderDataList[index]
                                                  .total
                                                  .toString(),
                                          order_status: int.parse(
                                              orderDataList[index]
                                                  .orderStatusId),
                                          order_quantity: orderDataList[index]
                                              .products
                                              .length,
                                          order_created_date: dateTime,
                                        ),
                                      ),
                                      int.parse(orderDataList[index]
                                                  .orderStatusId) ==
                                              1
                                          ? _showCancelButton(index)
                                          : Container(),
                                      int.parse(orderDataList[index]
                                                  .orderStatusId) <
                                              3
                                          ? _showEditButton(index)
                                          : Container(),
                                      int.parse(orderDataList[index]
                                                  .orderStatusId) ==
                                              4
                                          ? orderDataList[index]
                                                      .userDeliveryRating ==
                                                  null
                                              ? _showRatingButton(
                                                  context, index)
                                              : Container()
                                          : Container(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Divider(
                                          thickness: 5,
                                          color: UtilsImporter()
                                              .colorUtils
                                              .kmColors2,
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
                                              fontFamily: UtilsImporter()
                                                  .stringUtils
                                                  .HKGrotesk))))
                              : Container(),
                          isLoading
                              ? Container(
                                  height: 50.0,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Loader(),
                                  ),
                                )
                              : Container()
                        ])),
        ));
  }

  Widget _showCancelButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () async {
        setState(() {
          orderLoaded = false;
        });
        String x =
            await OrderServices.cancelOrder(orderDataList[index].id.toString());
        if (x == "true") {
          setState(() {
            orderLoaded = true;
            errorMessage = false;
          });
          Toast.show("تم إلغاء طلبك بنجاح", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          orderDataList[index].orderStatusId = "5";
        } else {
          setState(() {
            orderDataList[index].orderStatusId = "2";

            orderLoaded = true;
            errorMessage = true;

            errorMessageVlue = x;
          });
          // Toast.show("حدثت مشكلة أثناء إلغاء الطلب يرجى تحديث لصفحة", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: Colors.red[700],
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.cancel_order.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  _moveOrderProductsToCart({int orderIndex}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartServices.cartProducts.clear();
    String products_Id = "";
    String products_quantity = "";

    for (int i = 0;
        i < LoadingScreenServices.myOrdersList[orderIndex].products.length;
        i++) {
      ProductsData product = new ProductsData();
      Warehouse warehouses = new Warehouse();
      List<Warehouse> listWarehouses = [];

      WarehousePivot warehousePivot = new WarehousePivot();

      product.id =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].id;
      product.images =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].images;
      // product.isActive = Services.myOrdersList[index].products[i].
      product.name =
          LoadingScreenServices.myOrdersList[orderIndex].products[i].name;
      warehousePivot.price = LoadingScreenServices
          .myOrdersList[orderIndex].products[i].pivot.purchasePrice;
      warehouses.pivot = warehousePivot;
      listWarehouses.add(warehouses);
      product.warehouses = listWarehouses;
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
      products_Id += CartServices.cartProducts[i].id.toString() + ";";
      products_quantity +=
          CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", products_Id + "@" + products_quantity);

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cartFromUpdate',
      (Route<dynamic> route) => false,
    );
  }

  void _settingModalBottomSheet(context, int index) {
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, setState) => ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                            0, screenHeight * 0.02, 0, screenHeight * 0.02),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide()),
                        ),
                        child: Text('تقييم الخدمة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                color: UtilsImporter().colorUtils.primarycolor,
                                fontSize: 25)), //font color is diffrent
                      ),
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(17, screenHeight * 0.03, 17, 0),
                        child: Text(
                          "كيف كانت تجربة طلبك في كمّون؟ ( تقييمك وملاحظاتك تساعدنا في تطوير خدمة كمّون )",
                          style: TextStyle(
                              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                              color: Colors.black),
                        ), //font color is diffrent
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            0, screenHeight * 0.07, 17, screenHeight * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 40,
                              onPressed: () {
                                setState(() {
                                  rateValue = 1;
                                  // feedbackBloc.add(UpdateRateValue(rateValue: 1));
                                });
                              },
                              icon: Icon(Icons.mood_bad),
                              color: rateValue == 1 ? Colors.red : Colors.grey,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 40,
                              icon: Icon(Icons.sentiment_dissatisfied,
                                  color: rateValue == 2
                                      ? Colors.redAccent
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  rateValue = 2;
                                  //  feedbackBloc.add(UpdateRateValue(rateValue: 2));
                                });
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 40,
                              icon: Icon(Icons.sentiment_neutral,
                                  color: rateValue == 3
                                      ? Colors.amber
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  rateValue = 3;
                                  //  feedbackBloc.add(UpdateRateValue(rateValue: 3));
                                });
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 40,
                              icon: Icon(Icons.sentiment_satisfied,
                                  color: rateValue == 4
                                      ? Colors.lightGreen
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  rateValue = 4;
                                  //  feedbackBloc.add(UpdateRateValue(rateValue: 4));
                                });
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 40,
                              icon: Icon(Icons.sentiment_very_satisfied,
                                  color: rateValue == 5
                                      ? Colors.green
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  rateValue = 5;
                                  //  feedbackBloc.add(UpdateRateValue(rateValue: 5));
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(17, 0, 17, screenHeight * 0.03),
                        child: AutoSizeTextField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          controller: _textFieldController,
                          maxLines: 4,
                          onTap: _requestFocus,
                          focusNode: _focusNode,
                          cursorColor: Theme.of(context).cursorColor,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  //  color: AppColors.grayBorder,
                                  ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            labelStyle: TextStyle(
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk,
                                color: _focusNode.hasFocus
                                    ? Colors.orange
                                    : Colors.grey),
                            alignLabelWithHint: true,
                            labelText: 'شاركنا بأفكارك (إختياري)',
                          ),
                        ),
                      ),
                      _submitRating(index),
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(17, 0, 17, screenHeight * 0.17),
                      //   child: CCAppButton(
                      //     text: "Submit feedback",
                      //     onPressed: rateValue > 0
                      //         ? () {
                      //             feedbackBloc.add(SubmitRate(
                      //                 feedbackSection: widget.feedbackSection,
                      //                 clientId: _loadingProvider.clientId,
                      //                 comment: _textFieldController.text));
                      //           }
                      //         : null,
                      //   ),
                      // )
                    ],
                  ));
        });
  }

  Widget _showRatingButton(BuildContext ctx, int orderIndex) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () => _settingModalBottomSheet(ctx, orderIndex),
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: UtilsImporter().colorUtils.kmColors,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.rating_order.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  Widget _submitRating(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () async {
        setState(() {
          orderLoaded = false;
        });
        Navigator.of(context).pop();
        await OrderServices.rateOrder(
            orderId: orderDataList[index].id.toString(),
            userFeedback: _textFieldController.text + ".",
            rating: rateValue);
        orderDataList[index].userDeliveryRating = rateValue.toString();
        _getOrder();

        // KammunRestart.restartApp(context);
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.submit_feedback.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 20),
        child: showConfirmButtonWithGesture);
  }

  Widget _showEditButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () async {
        setState(() {
          orderLoaded = false;
          errorMessage = false;
        });
        bool x =
            await OrderServices.lockOrder(orderDataList[index].id.toString());
        if (x) {
          setState(() {
            orderLoaded = true;
            errorMessage = false;
          });
          _moveOrderProductsToCart(orderIndex: index);
          // Toast.show("بإمكانك تعديل طلبك الآن", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          orderDataList[index].underUpdate = "1";
        } else {
          setState(() {
            orderDataList[index].orderStatusId = "3";

            orderLoaded = true;
            errorMessage = true;
            errorMessageVlue =
                "لا يمكنك تعديل طلبك حالياً لانه تم الإنتهاء من تطبيق طلبك بنجاح";
          });

          // Toast.show("حدثت مشكلة أثناء إلغاء الطلب يرجى تحديث لصفحة", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            UtilsImporter().stringUtils.edit_order.toUpperCase(),
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        child: showConfirmButtonWithGesture);
  }

  void _onTileClicked(int index) {
    debugPrint("You tapped on item $index");

    List<OrderProducts> ordAry = orderDataList[index].products;

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new OrderDetailView(
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
                  delivery_price: (int.parse(orderDataList[index]
                              .supportedCityCost
                              .split(".")[0]) +
                          int.parse(
                              orderDataList[index].deliveryCost.split(".")[0]))
                      .toString(),
                )));
  }
}

class OrdersViewCard extends StatefulWidget {
  int order_quantity;
  String order_title;
  String order_total_price;
  int order_status;
  String order_created_date;
  int underUpdate;

  OrdersViewCard(
      {this.order_quantity,
      this.order_title,
      this.order_total_price,
      this.order_status,
      this.order_created_date,
      this.underUpdate});

  @override
  State<StatefulWidget> createState() {
    return OrdersViewCardState();
  }
}

class OrdersViewCardState extends State<OrdersViewCard> {
  String orderStatus = "طلبك قيد المعالجة ⌛️";
  @override
  Widget build(BuildContext context) {
    if (widget.order_status == 2)
      orderStatus = "تم قبول طلبك ✅";
    else if (widget.order_status == 3)
      orderStatus = "تم إرسال طلبك مع عامل التوصيل";
    else if (widget.order_status == 4)
      orderStatus = "تم توصيل طلبك بنجاح ";
    else if (widget.order_status == 5)
      orderStatus = "تم إلغاء الطلب من قبلكم 🚫";
    else if (widget.order_status == 6)
      orderStatus = "😔 لم نستطع تأمين الطلب 😔";

    if (widget.underUpdate == 1) {
      orderStatus = "طلبك معلق حتى تأكيد التعديل";
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: UtilsImporter()
                              .colorUtils
                              .greycolor
                              .withOpacity(0.2)),
                    ),
                    child: Text(
                      widget.order_quantity.toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "الفاتورة : ",
                                          style: TextStyle(
                                            color: UtilsImporter()
                                                .colorUtils
                                                .primarycolor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: UtilsImporter()
                                                .stringUtils
                                                .HKGrotesk,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${UtilsImporter().stringUtils.oCcy.format(int.parse(widget.order_total_price)).toString()}" +
                                              " ${LoadingScreenServices.companyInformation.currency.toString()}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: UtilsImporter()
                                                .stringUtils
                                                .HKGrotesk,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "تاريخ الطلب : ",
                                    style: TextStyle(
                                      color: UtilsImporter()
                                          .colorUtils
                                          .primarycolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.order_created_date,
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              orderStatus,
                              style: TextStyle(
                                  color: UtilsImporter().colorUtils.greycolor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

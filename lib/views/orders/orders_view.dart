import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/louck_order.dart';
import 'package:kammun_app/utils/kammun_button.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessagess.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Services.dart';
import 'package:intl/intl.dart';

import 'rating_view.dart';
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
    filterOrders = 0;

    if (LoadingScreenServices.myOrdersList.length == 0) {
      getOrders = _getOrder();
    } else {
      getOrders = _initalFunction();
      orderDataList = LoadingScreenServices.myOrdersList;
    }
    super.initState();
  }

  _initalFunction() {}

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageVlue = "";
  bool isLoading = false;
  int page = 1;
  bool theEndOfOrders = false;

  int filterOrders;

  List<String> orderStatus = [
    "فلترة الطلبات",
    "قيد المعالجة",
    "تم قبولها",
    "تم تجهيزها",
    "مع التوصيل",
    "تم توصيلها",
    "تم إلغائها",
    "تم رفضها"
  ];

  List<OrdersOriginalData> orderDataList = new List<OrdersOriginalData>();
  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
      LoadingScreenServices.myOrdersList.clear();
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
          if (filterOrders == 0) {
            orderDataList
                .removeWhere((order) => int.parse(order.orderStatusId) > 4);
          } else {
            orderDataList.removeWhere(
                (order) => int.parse(order.orderStatusId) != filterOrders);
          }
          Tools.logToConsole("orderDataList before filltiting");
          Tools.logToConsole(orderDataList.length);
          // for (int i = 0; i < orderDataList.length; i++) {
          //   orderDataList[i].products.removeWhere((theProduct) =>
          //       !LoadingScreenServices.subSupplierCodeHint
          //           .hasMatch(theProduct.supplierCode));
          // }
          orderDataList.removeWhere((order) => order.products.length == 0);
          Tools.logToConsole("orderDataList After filltiting");
          Tools.logToConsole(orderDataList.length);
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
              child: !orderLoaded || isLoading
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
                              DropdownButton(
                                value: filterOrders,
                                items: [
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: UtilsImporter()
                                              .stringUtils
                                              .HKGrotesk),
                                    ),
                                    value: 0,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[1],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 1,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[2],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 2,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[3],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 3,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[4],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 4,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[5],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 5,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[6],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 6,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text(
                                      orderStatus[7],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                    value: 7,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    filterOrders = value;
                                  });
                                  _getOrder();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      page++;
                                    });

                                    _getOrder();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 40,
                                    color: UtilsImporter().colorUtils.kmColors,
                                  ),
                                ),
                              ),
                              DropdownButton(
                                value: page,
                                items: [
                                  DropdownMenuItem<int>(
                                    child: Text("1"),
                                    value: 1,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("2"),
                                    value: 2,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("3"),
                                    value: 3,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("4"),
                                    value: 4,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("5"),
                                    value: 5,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("6"),
                                    value: 6,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("7"),
                                    value: 7,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("8"),
                                    value: 8,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("9"),
                                    value: 9,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("10"),
                                    value: 10,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("11"),
                                    value: 11,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("12"),
                                    value: 12,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("13"),
                                    value: 13,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("14"),
                                    value: 14,
                                  ),
                                  DropdownMenuItem<int>(
                                    child: Text("15"),
                                    value: 15,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    page = value;
                                  });
                                  _getOrder();
                                },
                              ),
                              //Text("$pageNumber"),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (page > 1) {
                                        page--;
                                      }
                                      _getOrder();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.last_page,
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
                                    DateFormat('kk:mm - yyyy-MM-dd')
                                        .format(orderDataList[index].createdAt);
                                return Column(
                                  children: <Widget>[
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => _onTileClicked(index),
                                      child: OrdersViewCard(
                                        orderId: orderDataList[index].id,
                                        entrance: orderDataList[index]
                                            .address
                                            .entrance,
                                        deliveryMethodId: int.parse(
                                            orderDataList[index]
                                                .deliveryMethodId),
                                        lat: orderDataList[index].address.lat !=
                                                "null"
                                            ? double.parse(orderDataList[index]
                                                .address
                                                .lat)
                                            : null,
                                        lon: orderDataList[index].address.lon !=
                                                "null"
                                            ? double.parse(orderDataList[index]
                                                .address
                                                .lon)
                                            : null,
                                        userNumber:
                                            orderDataList[index].userData.phone,
                                        address: orderDataList[index]
                                                .address
                                                .street +
                                            " " +
                                            orderDataList[index]
                                                .address
                                                .building +
                                            " طابق " +
                                            orderDataList[index].address.floor +
                                            " " +
                                            orderDataList[index]
                                                .address
                                                .description,
                                        supportedCityId: orderDataList[index]
                                            .supportedCityId,
                                        underUpdate: int.parse(
                                            orderDataList[index].underUpdate),
                                        order_title: "",
                                        order_total_price: orderDataList[index]
                                            .total
                                            .toString(),
                                        order_status: int.parse(
                                            orderDataList[index].orderStatusId),
                                        order_quantity: orderDataList[index]
                                            .products
                                            .length,
                                        order_created_date: dateTime,
                                      ),
                                    ),
                                    Wrap(
                                      children: [
                                        (int.parse(orderDataList[index]
                                                        .orderStatusId) <
                                                    5) &&
                                                (orderDataList[index]
                                                            .underUpdate ==
                                                        "0" ||
                                                    orderDataList[index]
                                                            .underUpdate ==
                                                        "2")
                                            ? _showEditButton(index)
                                            : Container(),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        _showAddSpendingButton(index),

                                        // _showAddImageToOrderButton(index),
                                      ],
                                    ),
                                    orderDataList[index].userNotes.toString() !=
                                            "null"
                                        ? _showUserNoteButton(index)
                                        : Container(),
                                    orderDataList[index]
                                                .underUpdate
                                                .toString() !=
                                            "0"
                                        ? _showUnlouckOrderButton(index)
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                          // isLoading
                          //     ? Container(
                          //         height: 50.0,
                          //         color: Colors.transparent,
                          //         child: Center(
                          //           child: Loader(),
                          //         ),
                          //       )
                          //     : Container()
                        ])),
        ));
  }

  void _showDialog({title = "ملاحظة العميل", body}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          content: new Text(
            "$body",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUnlockDialog({title = "إلغاء التعليق", int orderId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          content: new Text(
            "هل أنت متأكد انك تريد إلغاء تعليق الطلب قيامك بهذه العملية قد يلغي التعديلات التي يقوم بها الزبون او شريكك في العمل",
            // maxLines: 20,
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          scrollable: true,
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "نعم",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                submitSpending(orderId.toString(), isSpendingApi: false);
              },
            ),
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController _spendingController = new TextEditingController();
  TextEditingController _reasoneController = new TextEditingController();

  void submitSpending(String orderId, {bool isSpendingApi = true}) async {
    bool result;
    if (!isSpendingApi) {
      result = await OrderServices.unlouckOrder(orderId);
    } else {
      result = await OrderServices.addSpendingToOrder(
          orderId, _spendingController.text, _reasoneController.text);
    }

    if (result) {
      _spendingController.text = '';
      _reasoneController.text = '';
      Flushbar(
        backgroundColor: Colors.green[900],
        messageText: Text(
          "تم إضافة المصروف بنجاح",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk),
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.green,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        icon: Icon(
          Icons.assignment_turned_in,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
      if (!isSpendingApi) _getOrder();
    } else {
      Flushbar(
        backgroundColor: Colors.red[900],
        messageText: Text(
          "فشل بإضافة المصروف",
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
          Icons.close,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
      )..show(context);
    }
  }

  void _showAddSpendingDialog({title = "إضافة مصروف", int index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "$title",
            style: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
          ),
          content: Column(
            // shrinkWrap: true,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: _spendingController,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "المبلغ المدفوع",
                  hintStyle: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 3.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Color(0xFF999999),
                        width: 1.0,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: _reasoneController,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "سبب الدفع",
                  hintStyle: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 3.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Color(0xFF999999),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              KammunButton(
                text: "إضافة مصروف",
                onPress: () {
                  Navigator.of(context).pop();
                  submitSpending(orderDataList[index].id.toString());
                },
              ),
            ],
          ),
          scrollable: true,
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "إغلاق",
                style: TextStyle(
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showUnlouckOrderButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        _showUnlockDialog(orderId: orderDataList[index].id);
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: Colors.blue[800],
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            "إلغاء التعليق",
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

  Widget _showUserNoteButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        _showDialog(body: orderDataList[index].userNotes);
      },
      child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
            color: Colors.indigoAccent,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            "مشاهدة ملاحظة العميل ",
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

  Widget _showAddSpendingButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        _showAddSpendingDialog(index: index);
      },
      child: new Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: AutoSizeText(
            "إضافة مصروف",
            maxLines: 2,
            textAlign: TextAlign.center,
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

  Widget _showAddImageToOrderButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () {
        //  _showAddSpendingDialog(index: index);
      },
      child: new Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: new BoxDecoration(
            color: Colors.cyan,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: AutoSizeText(
            "إضافة صورة فاتورة",
            textAlign: TextAlign.center,
            maxLines: 1,
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

  Widget _showCancelButton(int index) {
    bool isOrderUnderUpdate = false;
    if (orderDataList[index].underUpdate == "1") {
      isOrderUnderUpdate = true;
    }
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

  _moveOrderProductsToCart(
      {int orderIndex, List<OrderProducts> orderProducts}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartServices.cartProducts.clear();
    String products_Id = "";
    String products_quantity = "";

    for (int i = 0; i < orderProducts.length; i++) {
      ProductData product = new ProductData();

      product.id = orderProducts[i].id;
      product.images = orderProducts[i].images;
      product.name = orderProducts[i].name;

      product.price = orderProducts[i].pivot.purchasePrice;

      product.productCount = int.parse(orderProducts[i].pivot.quantity);
      product.unit = orderProducts[i].unit;
      product.quantity = orderProducts[i].quantity;

      CartServices.addProductToCart(product);
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

  void _settingModalBottomSheet(context, int index, double screenHeight) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => RatingView(
        orderId: orderDataList[index].id.toString(),
        onReqestDone: () {
          orderDataList[index].userDeliveryRating = rateValue.toString();
          orderDataList.clear();

          _getOrder();
        },
      ),
    );
  }

  Widget _showRatingButton(
      BuildContext ctx, int orderIndex, double screenHeight) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () => _settingModalBottomSheet(ctx, orderIndex, screenHeight),
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

  Widget _showEditButton(int index) {
    final GestureDetector showConfirmButtonWithGesture = new GestureDetector(
      onTap: () async {
        setState(() {
          orderLoaded = false;
          errorMessage = false;
        });
        LouckOrder response =
            await OrderServices.lockOrder(orderDataList[index].id.toString());
        if (response != null) {
          if (response.success) {
            setState(() {
              orderLoaded = true;
              errorMessage = false;
            });
            _moveOrderProductsToCart(
                orderIndex: index, orderProducts: response.products);
            // Toast.show("بإمكانك تعديل طلبك الآن", context,
            //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            orderDataList[index].underUpdate = "1";
          } else if (!response.success) {
            setState(() {
              orderDataList[index].underUpdate = "2";
              orderLoaded = true;
              errorMessage = true;
              errorMessageVlue =
                  "لا يمكنك تعديل طلبك حالياً لأن مسؤول الطلب أو الزبون يقوم بتعديله حالياً";
            });
          }
        } else {
          setState(() {
            orderLoaded = true;
            errorMessage = true;
            errorMessageVlue =
                "حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت";
          });
        }
      },
      child: new Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width / 2.5,
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
    Tools.logToConsole("You tapped on item $index");

    List<OrderProducts> ordAry = orderDataList[index].products;

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new OrderDetailView(
                  orderId: orderDataList[index].id,
                  orderIndex: index,
                  ordersAry: ordAry,
                  addressName: orderDataList[index].address.street,
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
  int orderId;
  final String userNumber;
  final int deliveryMethodId;
  int order_quantity;
  String order_title;
  String order_total_price;
  int order_status;
  String order_created_date;
  int underUpdate;
  String supportedCityId;
  final String address;
  final double lat;
  final double lon;
  final String entrance;

  OrdersViewCard(
      {@required this.orderId,
      this.order_quantity,
      this.order_title,
      this.order_total_price,
      this.order_status,
      this.order_created_date,
      this.supportedCityId,
      this.address,
      this.lat,
      this.lon,
      this.userNumber,
      this.deliveryMethodId,
      @required this.entrance,
      this.underUpdate});

  @override
  State<StatefulWidget> createState() {
    return OrdersViewCardState();
  }
}

_makePhoneCall(String number) async {
  String url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openMapsSheet(context, lat, lon) async {
  try {
    final coords = Coords(lat, lon);
    final title = "Ocean Beach";
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: title,
                      ),
                      title: Text(map.mapName),
                      leading: Icon(Icons.map),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    print(e);
  }
}

class OrdersViewCardState extends State<OrdersViewCard> {
  String orderStatus = "طلبك قيد المعالجة ⌛️";
  @override
  Widget build(BuildContext context) {
    if (widget.order_status == 2) orderStatus = "تم قبول طلبك ✅";
    if (widget.order_status == 3) orderStatus = "تم تجهيز الطلب 😎";
    if (widget.order_status == 4)
      orderStatus = "تم إرسال طلبك مع كابتن التوصيل";
    if (widget.underUpdate == 1)
      orderStatus = "الطلب معلق حتى يأكد الزبون التعديل";

    if (widget.underUpdate == 2)
      orderStatus = "الطلب معلق حتى تقوم بتأكيد التعديل";

    if (widget.order_status == 5) orderStatus = "تم توصيل طلبك بنجاح ";
    if (widget.order_status == 6) orderStatus = "تم إلغاء الطلب من قبلكم 🚫";
    if (widget.order_status == 7) orderStatus = "😔 لم نستطع تأمين الطلب 😔";

    return Container(
      decoration: widget.deliveryMethodId == 2
          ? BoxDecoration(border: Border.all(color: Colors.red, width: 5))
          : widget.deliveryMethodId == 3
              ? BoxDecoration(border: Border.all(color: Colors.green, width: 5))
              : BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 5)),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "#${widget.orderId.toString().substring(3, widget.orderId.toString().length)}",
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                      ),
                                    ),
                                  )
                                ]),

                            SizedBox(height: 10),

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "رقم الهاتف : ",
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
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => _makePhoneCall(
                                                widget.userNumber),
                                          text: widget.userNumber,
                                          style: TextStyle(
                                            color: UtilsImporter()
                                                .colorUtils
                                                .kmColors,
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

                            Wrap(children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "العنوان : ",
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
                                      text: widget.address,
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
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "المدينة: ",
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
                                        text: LoadingScreenServices
                                                .supportedCitiesListIntro
                                                .where((supportedCity) =>
                                                    supportedCity.id
                                                        .toString() ==
                                                    widget.supportedCityId)
                                                .first
                                                .name +
                                            "   ",
                                        style: TextStyle(
                                          color: Colors.black,
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
                                widget.lat != null && widget.lon != null
                                    ? InkWell(
                                        child: Icon(
                                          Icons.delivery_dining,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                        onTap: () {
                                          openMapsSheet(
                                              context, widget.lat, widget.lon);
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "المدخل: ",
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
                                    text: widget.entrance,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
                                    ),
                                  ),
                                ],
                              ),
                            ),

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
                                  color: UtilsImporter().colorUtils.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontSize: 18),
                            ),

                            //supportedCitiesResponse
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

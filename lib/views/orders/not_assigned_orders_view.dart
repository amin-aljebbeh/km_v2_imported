import 'package:flutter/material.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/AlertMessages.dart';
import 'package:kammun_app/views/Wedgit/decision_button.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/Wedgit/orders_view_card.dart';
import 'package:kammun_app/views/Wedgit/screen_message.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';
import '../../Services.dart';
import 'package:intl/intl.dart';
import 'services/order_services.dart';

class NotAssignedOrdersView extends StatefulWidget {
  @override
  _NotAssignedOrdersViewState createState() => _NotAssignedOrdersViewState();
}

class _NotAssignedOrdersViewState extends State<NotAssignedOrdersView> {
  Future getOrders;
  int rateValue;

  @override
  void initState() {
    rateValue = 0;
    filterOrders = 0;

    if (Services.isShopper()) {
      if (Services.shopper.status == 1) {
        if (LoadingScreenServices.shoppersNotAssignedOrdersList.length == 0) {
          getOrders = _getOrder();
        } else {
          getOrders = _initialFunction();
          orderDataList = LoadingScreenServices.shoppersNotAssignedOrdersList;
        }
      }
    } else {
      if (LoadingScreenServices.deliveriesNotAssignedOrdersList.length == 0) {
        getOrders = _getOrder();
      } else {
        getOrders = _initialFunction();
        orderDataList = LoadingScreenServices.deliveriesNotAssignedOrdersList;
      }
    }

    super.initState();
  }

  _initialFunction() {}

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageValue = "";
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

  List<String> dropdownValues = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15"
  ];

  List<OrdersOriginalData> orderDataList = new List<OrdersOriginalData>();

  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
      LoadingScreenServices.shoppersNotAssignedOrdersList.clear();
      LoadingScreenServices.deliveriesNotAssignedOrdersList.clear();
    });
    var orderList;
    if (Services.isShopper()) {
      if (Services.shopper.status == 1) {
        if (LoadingScreenServices.shoppersNotAssignedOrdersList.length == 0) {
          orderList = await OrderServices.getOrdersNotAssignedToShoppers(
              pageNumber: page);
        } else {
          orderList = LoadingScreenServices.shoppersNotAssignedOrdersList;
        }
      }
    } else {
      if (LoadingScreenServices.deliveriesNotAssignedOrdersList.length == 0) {
        orderList = await OrderServices.getOrdersNotAssignedToDeliveries(
            pageNumber: page);
      } else {
        orderList = LoadingScreenServices.deliveriesNotAssignedOrdersList;
      }
    }
    if (orderList != null) {
      if (orderList.length == 0) {
        setState(() {
          if (Services.isShopper()) {
            LoadingScreenServices.shoppersNotAssignedOrdersList = orderDataList;
          } else {
            LoadingScreenServices.deliveriesNotAssignedOrdersList =
                orderDataList;
          }
          var tempList = orderDataList;
          if (tempList.length != 0) theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDataList = orderList;
          if (filterOrders == 0) {
            orderDataList
                .removeWhere((order) => int.parse(order.orderStatusId) > 4);
          } else {
            orderDataList.removeWhere(
                (order) => int.parse(order.orderStatusId) != filterOrders);
          }
          Tools.logToConsole("orderDataList before filltiting");
          Tools.logToConsole(orderDataList.length);

          orderDataList.removeWhere((order) => order.products.length == 0);
          Tools.logToConsole("orderDataList After filltiting");
          Tools.logToConsole(orderDataList.length);
          if (Services.isShopper()) {
            LoadingScreenServices.shoppersNotAssignedOrdersList = orderDataList;
          } else {
            LoadingScreenServices.deliveriesNotAssignedOrdersList =
                orderDataList;
          }
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
        errorMessageValue = "حدث خطأ اثناء محاولة جلب الطلبات";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    if (Services.isShopper()) {
      if (Services.shopper.status == 0)
        return ScreenMessage(message: 'انت لا تستقبل الطلبات حالياً');
    }
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
                        DropdownButton(
                          value: filterOrders,
                          items: Services.dropdownStringList(orderStatus),
                          onChanged: (value) {
                            setState(() {
                              filterOrders = value;
                              page = 1;
                            });
                            _getOrder();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: IconButton(
                            onPressed: () {
                              if (page < 14)
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
                          items: Services.dropdownIntList(dropdownValues),
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
                        ? Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.4),
                            child: ScreenMessage(
                                message: 'لا يوجد أي طلبات سابقة'),
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
                        itemCount:
                            orderDataList == null ? 0 : orderDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String dateTime = DateFormat('kk:mm - yyyy-MM-dd')
                              .format(orderDataList[index].createdAt);
                          return Column(
                            children: <Widget>[
                              new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => _onTileClicked(index),
                                child: OrdersViewCard(
                                  deliveryName:
                                      orderDataList[index].delivery != null
                                          ? orderDataList[index].delivery.name
                                          : null,
                                  shopperName:
                                      orderDataList[index].shopper != null
                                          ? orderDataList[index].shopper.name
                                          : null,
                                  orderId: orderDataList[index].id,
                                  entrance:
                                      orderDataList[index].address.entrance,
                                  deliveryMethodId: int.parse(
                                      orderDataList[index].deliveryMethodId),
                                  lat:
                                      orderDataList[index].address.lat != "null"
                                          ? double.parse(
                                              orderDataList[index].address.lat)
                                          : null,
                                  lon:
                                      orderDataList[index].address.lon != "null"
                                          ? double.parse(
                                              orderDataList[index].address.lon)
                                          : null,
                                  userNumber:
                                      orderDataList[index].userData.phone,
                                  address: orderDataList[index].address.street +
                                      " " +
                                      orderDataList[index].address.building +
                                      " طابق " +
                                      orderDataList[index].address.floor +
                                      " " +
                                      orderDataList[index].address.description,
                                  supportedCityId:
                                      orderDataList[index].supportedCityId,
                                  underUpdate: int.parse(
                                      orderDataList[index].underUpdate),
                                  orderTitle: "",
                                  orderTotalPrice:
                                      orderDataList[index].total.toString(),
                                  orderStatus: int.parse(
                                      orderDataList[index].orderStatusId),
                                  orderQuantity:
                                      orderDataList[index].products.length,
                                  orderCreatedDate: dateTime,
                                ),
                              ),
                              if (Services.isDelivery() || Services.isShopper())
                                DecisionButton(
                                  text: UtilsImporter().stringUtils.getOrder,
                                  color: Colors.red,
                                  onTap: () {
                                    OrderServices.assignOrder(
                                        orderDataList[index].id.toString());
                                    setState(() {});
                                    _getOrder();
                                  },
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              orderDataList[index].userNotes.toString() !=
                                      "null"
                                  ? DecisionButton(
                                      text:
                                          UtilsImporter().stringUtils.watchNote,
                                      onTap: () {
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text: UtilsImporter()
                                                .stringUtils
                                                .close,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ];
                                        showMyDialog(
                                            UtilsImporter()
                                                .stringUtils
                                                .costumerNote,
                                            orderDataList[index].userNotes,
                                            decisionButtons,
                                            null,
                                            context);
                                      },
                                      color: Colors.indigoAccent,
                                    )
                                  : Container(),
                              orderDataList[index].underUpdate.toString() != "0"
                                  ? DecisionButton(
                                      text: UtilsImporter().stringUtils.unLock,
                                      onTap: () {
                                        int orderId = orderDataList[index].id;
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text:
                                                UtilsImporter().stringUtils.yes,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              unLockOrder(orderId.toString(),
                                                  isSpendingApi: false);
                                            },
                                          ),
                                          DialogButton(
                                            text: UtilsImporter()
                                                .stringUtils
                                                .close,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ];

                                        showMyDialog(
                                            UtilsImporter().stringUtils.unLock,
                                            UtilsImporter()
                                                .stringUtils
                                                .unLockConfirm,
                                            decisionButtons,
                                            null,
                                            context);
                                        // _showDialog(
                                        //     body: orderDataList[index]
                                        //         .userNotes);
                                      },
                                      color: Colors.blue[800],
                                    )
                                  // _showUnlockOrderButton(index)
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Divider(
                                  thickness: 5,
                                  color: UtilsImporter().colorUtils.kmColors2,
                                ),
                              )
                            ],
                          );
                          // return Container(
                          //   height: 0.01,
                          //   width: 0.01,
                          // );
                        },
                      ),
                    ),
                    theEndOfOrders
                        ? ScreenMessage(
                            message: "تم جلب جميع الطلبات",
                          )
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }

  void unLockOrder(String orderId, {bool isSpendingApi = true}) async {
    await OrderServices.unlockOrder(orderId);
  }

  void _onTileClicked(int index) {
    Tools.logToConsole("You tapped on item $index");

    List<OrderProducts> ordAry = orderDataList[index].products;

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new OrderDetailView(
          order: orderDataList[index],
          orderId: orderDataList[index].id,
          orderIndex: index,
          ordersAry: ordAry,
          addressName: orderDataList[index].address.street,
          subTotal:
              int.parse(orderDataList[index].total.toString().split(".")[0]) -
                  int.parse(orderDataList[index]
                      .supportedCityCost
                      .toString()
                      .split(".")[0]) -
                  int.parse(orderDataList[index].deliveryCost.split(".")[0]),
          total: orderDataList[index].total.toString(),
          deliveryPrice: (int.parse(
                      orderDataList[index].supportedCityCost.split(".")[0]) +
                  int.parse(orderDataList[index].deliveryCost.split(".")[0]))
              .toString(),
        ),
      ),
    );
  }
}

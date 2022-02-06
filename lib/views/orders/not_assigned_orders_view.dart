import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import '../../Services.dart';
import 'services/order_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

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

    getOrders = _initialFunction();
    _getOrder();
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

  List<OrdersOriginalData> orderDataList = new List<OrdersOriginalData>();

  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
    });
    List<OrdersOriginalData> orderList = new List<OrdersOriginalData>();
    if (LoadingScreenServices.notAssignedOrdersList.length == 0) {
      if (Services.isShopper()) orderList = await OrderServices.getOrdersNotAssignedToShoppers(pageNumber: page);
      if (Services.isDelivery())
        orderList = await OrderServices.getOrdersNotAssignedToDeliveries(pageNumber: page);
    } else {
      orderList = LoadingScreenServices.notAssignedOrdersList;
    }
    if (orderList != null) {
      if (orderList.length == 0) {
        setState(() {
          if (Services.isShopper()) {
            LoadingScreenServices.notAssignedOrdersList = orderDataList;
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
            orderDataList.removeWhere((order) => int.parse(order.orderStatusId) > 4);
          } else {
            orderDataList.removeWhere((order) => int.parse(order.orderStatusId) != filterOrders);
          }

          orderDataList.removeWhere((order) => order.products.length == 0);
          LoadingScreenServices.notAssignedOrdersList = orderDataList;
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
                          items: Services.dropdownStringList(StringUtils.orderStatus),
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
                              color: ColorUtils.kmColors,
                            ),
                          ),
                        ),
                        DropdownButton(
                          value: page,
                          items: Services.dropdownIntList(StringUtils.dropdownValues),
                          onChanged: (value) {
                            setState(() {
                              page = value;
                            });
                            _getOrder();
                          },
                        ),
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
                              color: ColorUtils.kmColors,
                            ),
                          ),
                        ),
                      ],
                    ),
                    orderDataList.length == 0
                        ? Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.4),
                            child: ScreenMessage(message: 'لا يوجد أي طلبات سابقة'),
                          )
                        : Container(
                            padding: EdgeInsets.zero,
                          ),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: orderDataList == null ? 0 : orderDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          orderDataList[index].orderArithmeticOperations();
                          if (Services.isShopper()) orderDataList[index].orderProfits();
                          return Column(
                            children: <Widget>[
                              OrdersViewCard(
                                orderData: orderDataList[index],
                                orderType: OrderTypes.orders,
                              ),
                              if (Services.isDelivery() || Services.isShopper())
                                KammunButton(
                                  text: StringUtils.getOrder,
                                  color: Colors.green[800],
                                  onTap: () {
                                    OrderServices.assignOrder(orderDataList[index].id.toString());
                                    setState(() {
                                      orderDataList.removeAt(index);
                                    });
                                  },
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              orderDataList[index].userNotes.toString() != "null"
                                  ? KammunButton(
                                      text: StringUtils.watchNote,
                                      onTap: () {
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text: StringUtils.close,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ];
                                        showMyDialog(
                                            title: StringUtils.costumerNote,
                                            text: orderDataList[index].userNotes,
                                            dialogButtons: decisionButtons,
                                            context: context);
                                      },
                                      color: Colors.indigoAccent,
                                    )
                                  : Container(),
                              orderDataList[index].underUpdate.toString() != "0"
                                  ? KammunButton(
                                      text: StringUtils.unLock,
                                      onTap: () {
                                        int orderId = orderDataList[index].id;
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text: StringUtils.yes,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              unLockOrder(orderId.toString(), isSpendingApi: false);
                                            },
                                          ),
                                          DialogButton(
                                            text: StringUtils.close,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ];

                                        showMyDialog(
                                            title: StringUtils.unLock,
                                            text: StringUtils.unLockConfirm,
                                            dialogButtons: decisionButtons,
                                            context: context);
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
                                  color: ColorUtils.kmColors2,
                                ),
                              )
                            ],
                          );
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
}

import 'package:flutter/material.dart';
import 'package:kammun_app/models/lock_order.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
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
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:intl/intl.dart';
import 'services/order_services.dart';

class AssignedOrdersView extends StatefulWidget {
  @override
  _AssignedOrdersViewState createState() => _AssignedOrdersViewState();
}

class _AssignedOrdersViewState extends State<AssignedOrdersView> {
  Future getOrders;
  int rateValue;

  @override
  void initState() {
    rateValue = 0;
    filterOrders = 0;

    if (LoadingScreenServices.myOrdersList.length == 0) {
      getOrders = _getOrder();
    } else {
      getOrders = _initialFunction();
      orderDataList = LoadingScreenServices.myOrdersList;
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
    print('getAssignedOrder');
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
      LoadingScreenServices.myOrdersList.clear();
    });
    var orderList;
    if (LoadingScreenServices.myOrdersList.length == 0) {
      if (Services.isDelivery())
        orderList = await OrderServices.getDeliveryOrders(pageNumber: page);
      else
        orderList = await OrderServices.getShopperOrders(pageNumber: page);
    } else {
      orderList = LoadingScreenServices.myOrdersList;
    }
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
          orderDataList = orderList;
          // orderDataList.addAll(orderList);
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
                          items: Services.dropdownStringList(orderStatus),
                          onChanged: (value) {
                            setState(() {
                              filterOrders = value;
                              page = 1;
                            });
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
                        ? Container(
                            child: Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.4),
                              child: Center(
                                child: Text(
                                  "لا يوجد أي طلبات سابقة",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: UtilsImporter().colorUtils.greycolor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
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
                        itemCount:
                            orderDataList == null ? 0 : orderDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String dateTime = DateFormat('a h:mm - dd-MM-yyyy')
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
                              DecisionButton(
                                text: UtilsImporter().stringUtils.edit_order,
                                onTap: () async {
                                  setState(
                                    () {
                                      orderLoaded = false;
                                      errorMessage = false;
                                    },
                                  );
                                  LockOrder response =
                                      await OrderServices.lockOrder(
                                          orderId: orderDataList[index]
                                              .id
                                              .toString(),
                                          userNote:
                                              orderDataList[index].userNotes,
                                          supportedCityCost:
                                              orderDataList[index]
                                                  .supportedCityCost,
                                          deliveryMethodCost:
                                              orderDataList[index].deliveryCost,
                                          deliveryMethodId: int.parse(
                                              orderDataList[index]
                                                  .deliveryMethodId
                                                  .toString()));
                                  if (response != null) {
                                    if (response.success) {
                                      setState(() {
                                        orderLoaded = true;
                                        errorMessage = false;
                                      });
                                      _moveOrderProductsToCart(
                                          orderIndex: index,
                                          orderProducts: response.products);
                                      orderDataList[index].underUpdate = "1";
                                    } else if (!response.success) {
                                      setState(() {
                                        orderDataList[index].underUpdate = "2";
                                        orderLoaded = true;
                                        errorMessage = true;
                                        errorMessageValue =
                                            "لا يمكنك تعديل طلبك حالياً لأن مسؤول الطلب أو الزبون يقوم بتعديله حالياً";
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
                                color: Colors.green,
                              ),
                              orderDataList[index].userNotes.toString() !=
                                      "null"
                                  ? DecisionButton(
                                      text: 'مشاهدة ملاحظة العميل',
                                      onTap: () {
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text: 'إغلاق',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ];
                                        showMyDialog(
                                            'ملاحظة العميل',
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
                                      text: "إلغاء التعليق",
                                      onTap: () {
                                        int orderId = orderDataList[index].id;
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text: 'نعم',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              submitSpending(orderId.toString(),
                                                  isSpendingApi: false);
                                              setState(() {
                                                orderDataList[index]
                                                    .underUpdate = '0';
                                              });
                                            },
                                          ),
                                          DialogButton(
                                            text: 'إغلاق',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ];

                                        showMyDialog(
                                            "إلغاء التعليق",
                                            "هل أنت متأكد انك تريد إلغاء تعليق الطلب قيامك بهذه العملية قد يلغي التعديلات التي يقوم بها الزبون او شريكك في العمل",
                                            decisionButtons,
                                            null,
                                            context);
                                        // _showDialog(
                                        //     body: orderDataList[index]
                                        //         .userNotes);
                                      },
                                      color: Colors.blue[800],
                                    )
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
                        },
                      ),
                    ),
                    theEndOfOrders
                        ? Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.4),
                            child: ScreenMessage(
                                message: 'لا يوجد أي طلبات سابقة'),
                          )
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }

  TextEditingController _spendingController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();

  void submitSpending(String orderId, {bool isSpendingApi = true}) async {
    bool result;
    if (!isSpendingApi) {
      result = await OrderServices.unlockOrder(orderId);
    } else {
      result = await OrderServices.addSpendingToOrder(
          orderId, _spendingController.text, _reasonController.text);
    }

    Services.resultFlushBar(context: context, result: result);
    if (result) {
      _spendingController.text = '';
      _reasonController.text = '';
    }
  }

  _moveOrderProductsToCart(
      {int orderIndex, List<OrderProducts> orderProducts}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartServices.cartProducts.clear();
    String productsId = "";
    String productsQuantity = "";

    for (int i = 0; i < orderProducts.length; i++) {
      if (orderProducts[i].pivot.deletedAt == null) {
        ProductData product = new ProductData();

        product.id = orderProducts[i].id;
        product.images = orderProducts[i].images;
        product.name = orderProducts[i].name;

        product.price = orderProducts[i].pivot.purchasePrice;

        product.productCount = int.parse(orderProducts[i].pivot.quantity);
        product.unit = orderProducts[i].unit;
        product.quantity = orderProducts[i].quantity;
        product.subWarehouseId = orderProducts[i].subWarehouseId;

        CartServices.addProductToCart(product);
      }
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

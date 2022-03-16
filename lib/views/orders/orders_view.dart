import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services.dart';
import 'orders_view_importer.dart';
import 'services/order_services.dart';

class OrdersView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrdersViewState();
  }
}

class OrdersViewState extends State<OrdersView> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  Future getOrders;
  int rateValue;

  @override
  void initState() {
    rateValue = 0;
    ordersFilter = LoadingScreenServices.ordersViewFilter;
    ordersTypeFilter = 0;

    if (LoadingScreenServices.allOrdersList.length == 0) {
      getOrders = _getOrder();
    } else {
      getOrders = _initialFunction();
      orderDataList = LoadingScreenServices.allOrdersList;
    }
    super.initState();
  }

  _initialFunction() {}

  bool orderLoaded = true;
  bool generalLoaded = true;
  bool errorMessage = false;
  String errorMessageValue = "";
  bool isLoading = false;
  int page = 1;
  int indexPage = 1;
  bool theEndOfOrders = false;

  int ordersFilter;
  int ordersTypeFilter;

  List<OrdersOriginalData> orderDataList = new List<OrdersOriginalData>();

  _getOrder() async {
    setState(() {
      if (indexPage == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
    });
    var orderList;
    if (LoadingScreenServices.allOrdersList.length == 0)
      orderList = await Services.getAllOrders(pageNumber: indexPage);
    else
      orderList = LoadingScreenServices.allOrdersList;

    if (orderList != null) {
      if (orderList.length == 0) {
        setState(() {
          if (LoadingScreenServices.allOrdersList.length != 0) theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDataList.addAll(orderList);
          if (generalLoaded) {
            if (ordersFilter == 0) {
              orderDataList.removeWhere((order) => int.parse(order.orderStatusId) > 4);
            } else {
              orderDataList.removeWhere((order) => int.parse(order.orderStatusId) != ordersFilter);
            }
          } else
            switch (ordersTypeFilter) {
              case (0):
                orderDataList.removeWhere((order) => order.delivery == null);
                break;
              case (1):
                orderDataList.removeWhere((order) => order.delivery != null);
                break;
              case (2):
                orderDataList.removeWhere((order) => order.shopper == null);
                break;
              case (3):
                orderDataList.removeWhere((order) => order.shopper != null);
                break;
            }

          orderDataList.removeWhere((order) => order.products.length == 0);
          LoadingScreenServices.allOrdersList = orderDataList;
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
          padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
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
                        Column(
                          children: [
                            DropdownButton(
                              value: ordersFilter,
                              items: Services.dropdownStringList(StringUtils.orderStatus),
                              onChanged: (value) {
                                setState(() {
                                  generalLoaded = true;
                                  ordersFilter = value;
                                  LoadingScreenServices.ordersViewFilter = value;
                                  page = 1;
                                  indexPage = 1;
                                });
                                _getOrder();
                              },
                            ),
                            DropdownButton(
                              value: ordersTypeFilter,
                              items: Services.dropdownStringList(StringUtils.orderTypes),
                              onChanged: (value) {
                                setState(() {
                                  generalLoaded = false;
                                  ordersTypeFilter = value;
                                  page = 1;
                                  indexPage = 1;
                                });
                                _getOrder();
                              },
                            ),
                          ],
                        ),
                        SearchOrderByPhoneNumber(
                          context: context,
                          onChoose: (number) async {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (screenContext) => new PhoneNumberOrdersView(
                                  phoneNumber: number,
                                ),
                              ),
                            );
                          },
                          controller: phoneNumberController,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              indexPage++;
                              if (page < 15) page++;
                            });
                            _getOrder();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40,
                            color: ColorUtils.kmColors,
                          ),
                        ),
                        DropdownButton(
                          value: page,
                          items: Services.dropdownIntList(StringUtils.dropdownValues),
                          onChanged: (value) {
                            setState(() {
                              page = value;
                              indexPage = value;
                            });
                            _getOrder();
                          },
                        ),
                        if (Services.isSuperAdmin())
                          EntryField(
                            controller: pageController,
                            onSubmit: (notEmpty) {
                              if (notEmpty) {
                                if (int.parse(pageController.text) > 0) {
                                  setState(() {
                                    indexPage = int.parse(pageController.text);
                                    if (indexPage <= 15) page = indexPage;
                                    _getOrder();
                                  });
                                }
                              }
                            },
                            width: MediaQuery.of(context).size.width * 0.13,
                            isPhoneNumber: false,
                            canBeEmpty: false,
                          ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (indexPage > 1 && indexPage <= 15) {
                                page--;
                              }
                              if (indexPage > 1) indexPage--;
                              _getOrder();
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 40,
                            color: ColorUtils.kmColors,
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
                                    color: ColorUtils.greyColor,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: orderDataList == null ? 0 : orderDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          orderDataList[index].orderArithmeticOperations();
                          orderDataList[index].orderProfits();
                          return Column(
                            children: <Widget>[
                              OrdersViewCard(
                                orderData: orderDataList[index],
                                orderType: OrderTypes.allOrder,
                              ),
                              if (int.parse(orderDataList[index].orderStatusId) <= 4 &&
                                  int.parse(orderDataList[index].underUpdate) != 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      KammunButton(
                                        text: orderDataList[index].orderStatusId == "1"
                                            ? "قبول الطلب"
                                            : orderDataList[index].orderStatusId == "2"
                                                ? "الطلب جاهز"
                                                : orderDataList[index].orderStatusId == "3"
                                                    ? "مع التوصيل"
                                                    : "تم التوصيل",
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        color: orderDataList[index].orderStatusId == "1"
                                            ? Colors.green[700]
                                            : orderDataList[index].orderStatusId == "2"
                                                ? Colors.yellow[700]
                                                : Colors.cyan[700],
                                        onTap: () async {
                                          int changeStatus = 0;
                                          setState(() {
                                            isLoading = true;
                                            errorMessage = false;
                                          });
                                          if (orderDataList[index].orderStatusId == "1")
                                            changeStatus = 2;
                                          else if (orderDataList[index].orderStatusId == "2")
                                            changeStatus = 3;
                                          else if (orderDataList[index].orderStatusId == "3")
                                            changeStatus = 4;
                                          else if (orderDataList[index].orderStatusId == "4") changeStatus = 5;

                                          bool x = await OrderServices.changeOrderStatus(
                                              orderDataList[index].id.toString(), changeStatus);

                                          if (x) {
                                            setState(() {
                                              orderDataList[index].orderStatusId = changeStatus.toString();
                                              isLoading = false;
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                              errorMessage = true;
                                            });
                                          }
                                        },
                                      ),
                                      KammunButton(
                                        onLongPress: () {
                                          List<DialogButton> decisionButton = [
                                            DialogButton(
                                              text: 'نعم',
                                              onTap: () async {
                                                int changeStatus = 0;
                                                Navigator.of(context).pop();

                                                setState(() {
                                                  isLoading = true;
                                                  errorMessage = false;
                                                });
                                                changeStatus = 7;

                                                bool x = await OrderServices.changeOrderStatus(
                                                    orderDataList[index].id.toString(), changeStatus);

                                                if (x) {
                                                  setState(() {
                                                    orderDataList[index].orderStatusId = changeStatus.toString();
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isLoading = false;
                                                    errorMessage = true;
                                                  });
                                                }
                                              },
                                            ),
                                            DialogButton(
                                              text: StringUtils.no,
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ];
                                          showMyDialog(
                                              title: "رفض الطلب",
                                              text: "هل أنت متأكد انك تريد رفض الطلب ؟",
                                              dialogButtons: decisionButton,
                                              context: context);
                                        },
                                        text: StringUtils.cancelOrder,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        color: Colors.red,
                                        onTap: () {
                                          List<DialogButton> decisionButton = [
                                            DialogButton(
                                              text: 'نعم',
                                              onTap: () async {
                                                int changeStatus = 0;
                                                Navigator.of(context).pop();

                                                setState(() {
                                                  isLoading = true;
                                                  errorMessage = false;
                                                });
                                                changeStatus = 6;

                                                bool x = await OrderServices.changeOrderStatus(
                                                    orderDataList[index].id.toString(), changeStatus);

                                                if (x) {
                                                  setState(() {
                                                    orderDataList[index].orderStatusId = changeStatus.toString();
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isLoading = false;
                                                    errorMessage = true;
                                                  });
                                                }
                                              },
                                            ),
                                            DialogButton(
                                              text: StringUtils.no,
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ];
                                          showMyDialog(
                                              title: "إلغاء الطلب",
                                              text: "هل أنت متأكد انك تريد إلغاء الطلب ؟",
                                              dialogButtons: decisionButton,
                                              context: context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              if (['6', '7'].contains(orderDataList[index].orderStatusId))
                                KammunButton(
                                  text: "استعادة الطلب",
                                  width: MediaQuery.of(context).size.width,
                                  color: ColorUtils.kmColors,
                                  onTap: () {
                                    List<DialogButton> decisionButton = [
                                      DialogButton(
                                        text: 'نعم',
                                        onTap: () async {
                                          int changeStatus = 0;
                                          Navigator.of(context).pop();

                                          setState(() {
                                            isLoading = true;
                                            errorMessage = false;
                                          });
                                          changeStatus = 1;

                                          bool result = await OrderServices.changeOrderStatus(
                                              orderDataList[index].id.toString(), changeStatus);
                                          Services.resultFlushBar(context: context, result: result);

                                          if (result) {
                                            setState(() {
                                              orderDataList[index].orderStatusId = changeStatus.toString();
                                              isLoading = false;
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                              errorMessage = true;
                                            });
                                          }
                                        },
                                      ),
                                      DialogButton(
                                        text: 'لا',
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ];
                                    showMyDialog(
                                        title: "استعادة الطلب",
                                        text: "هل أنت متأكد انك تريد استعادة الطلب ؟",
                                        dialogButtons: decisionButton,
                                        context: context);
                                  },
                                ),
                              KammunButton(
                                text: StringUtils.editOrder,
                                onTap: () async {
                                  setState(
                                    () {
                                      orderLoaded = false;
                                      errorMessage = false;
                                    },
                                  );
                                  LockOrder response = await OrderServices.lockOrder(
                                      orderId: orderDataList[index].id.toString(),
                                      userNote: orderDataList[index].userNotes,
                                      supportedCityCost: orderDataList[index].supportedCityCost,
                                      deliveryMethodCost: orderDataList[index].deliveryCost,
                                      deliveryMethodId:
                                          int.parse(orderDataList[index].deliveryMethodId.toString()));
                                  if (response != null) {
                                    if (response.success) {
                                      setState(() {
                                        orderLoaded = true;
                                        errorMessage = false;
                                      });
                                      _moveOrderProductsToCart(
                                          orderIndex: index, orderProducts: response.products);
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
                              orderDataList[index].userNotes.toString() != "null"
                                  ? KammunButton(
                                      text: StringUtils.watchNote,
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
                                            text: 'نعم',
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              bool result = await OrderServices.unlockOrder(orderId.toString());
                                              Services.resultFlushBar(context: context, result: result);
                                              setState(() {
                                                if (result) orderDataList[index].underUpdate = '0';
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
                                            title: StringUtils.unLock,
                                            text: StringUtils.unLockConfirm,
                                            dialogButtons: decisionButtons,
                                            context: context);
                                      },
                                      color: Colors.blue[800],
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Divider(
                                  thickness: 5,
                                  color: ColorUtils.kmColors2,
                                ),
                              ),
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
                              child: Text(
                                "تم جلب جميع الطلبات",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }

  _moveOrderProductsToCart({int orderIndex, List<OrderProducts> orderProducts}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartServices.cartProducts.clear();
    String productsId = "";
    String productsQuantity = "";

    orderProducts.removeWhere((element) => element.pivot.deletedAt != 'null');

    for (int i = 0; i < orderProducts.length; i++) {
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

    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ";";
      productsQuantity += CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", productsId + "@" + productsQuantity);

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cartFromUpdate',
      (Route<dynamic> route) => false,
    );
  }
}

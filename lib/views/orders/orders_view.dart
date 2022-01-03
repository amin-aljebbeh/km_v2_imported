import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/common_utils.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/order_detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'package:intl/intl.dart';
import 'services/order_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

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
    ordersFilter = 0;
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
          if (LoadingScreenServices.allOrdersList.length != 0)
            theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDataList.addAll(orderList);
          if (generalLoaded) {
            if (ordersFilter == 0) {
              orderDataList
                  .removeWhere((order) => int.parse(order.orderStatusId) > 4);
            } else {
              orderDataList.removeWhere(
                  (order) => int.parse(order.orderStatusId) != ordersFilter);
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
                        Column(
                          children: [
                            DropdownButton(
                              value: ordersFilter,
                              items: Services.dropdownStringList(
                                  StringUtils.orderStatus),
                              onChanged: (value) {
                                setState(() {
                                  generalLoaded = true;
                                  ordersFilter = value;
                                  page = 1;
                                  indexPage = 1;
                                });
                                _getOrder();
                              },
                            ),
                            DropdownButton(
                              value: ordersTypeFilter,
                              items: Services.dropdownStringList(
                                  StringUtils.orderTypes),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: IconButton(
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
                        ),
                        DropdownButton(
                          value: page,
                          items: Services.dropdownIntList(
                              StringUtils.dropdownValues),
                          onChanged: (value) {
                            setState(() {
                              page = value;
                              indexPage = value;
                            });
                            _getOrder();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (indexPage > 1 && indexPage < 15) {
                                  page--;
                                }
                                if (indexPage > 1) indexPage--;
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
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                            orderDataList == null ? 0 : orderDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (LoadingScreenServices.subWarehouses[0].warehouseId
                              .toString()
                              .contains(orderDataList[index].warehouseId)) {
                            orderDataList[index].initOrderRow();
                            orderDataList[index].accountOrderRows();
                          }

                          String shopper;
                          String dateTime = DateFormat('a h:mm - dd-MM-yyyy')
                              .format(orderDataList[index].createdAt);
                          return Column(
                            children: <Widget>[
                              new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => _onTileClicked(index),
                                child: OrdersViewCard(
                                  orderData: orderDataList[index],
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
                                  orderTotalPrice:
                                      orderDataList[index].total.toString(),
                                  orderStatus: int.parse(
                                      orderDataList[index].orderStatusId),
                                  orderQuantity:
                                      orderDataList[index].products.length,
                                  orderCreatedDate: dateTime,
                                ),
                              ),
                              if (Services.isAdmin() ||
                                  Services.isOperationManager())
                                Container(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Column(
                                    children: [
                                      KSearchableDropdown(
                                        hint: orderDataList[index].shopper !=
                                                null
                                            ? orderDataList[index].shopper.name
                                            : StringUtils.chooseShopper,
                                        search: shopper,
                                        items: Services.shoppersNameList(),
                                        onChanged: (value) async {
                                          if (value != null) {
                                            String shopperId =
                                                Services.selectedShopperId(
                                                    value);
                                            setState(() {
                                              shopper = value;
                                              orderDataList[index].shopper =
                                                  new Assigned(
                                                      name: value
                                                          .replaceAll(' ✅', '')
                                                          .replaceAll(' ❌', ''),
                                                      id: int.parse(shopperId));
                                            });
                                            bool result = await OrderServices
                                                .assignOrderToShopper(
                                                    shopperId,
                                                    orderDataList[index]
                                                        .id
                                                        .toString());
                                            Services.resultFlushBar(
                                                context: context,
                                                result: result);
                                          }
                                        },
                                      ),
                                      // KSearchableDropdown(
                                      //   search: delivery,
                                      //   hint: orderDataList[index].delivery !=
                                      //           null
                                      //       ? orderDataList[index].delivery.name
                                      //       : UtilsImporter()
                                      //           .stringUtils
                                      //           .chooseDelivery,
                                      //   items: Services.deliveriesNameList(),
                                      //   onChanged: (value) async {
                                      //     if (value != null) {
                                      //       int deliverId =
                                      //           LoadingScreenServices
                                      //               .allDeliveries
                                      //               .firstWhere((element) =>
                                      //                   element.name == value)
                                      //               .id;
                                      //       setState(() {
                                      //         orderDataList[index].delivery =
                                      //             Assigned(
                                      //                 id: deliverId,
                                      //                 name: value);
                                      //       });
                                      //       bool result = await OrderServices
                                      //           .assignOrderToDelivery(
                                      //               deliverId.toString(),
                                      //               orderDataList[index]
                                      //                   .id
                                      //                   .toString());
                                      //       Services.resultFlushBar(
                                      //           context: context,
                                      //           result: result);
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
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
                                            text:
                                                orderDataList[index].userNotes,
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

    orderProducts.removeWhere((element) => element.pivot.deletedAt != null);

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
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new OrderDetailView(
          orderData: orderDataList[index],
          orderId: orderDataList[index].id,
          ordersAry: orderDataList[index].products,
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
          orderType: OrderType.allOrder,
        ),
      ),
    );
  }
}

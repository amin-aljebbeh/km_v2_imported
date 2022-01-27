import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services.dart';
import 'services/order_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

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

  List<OrdersOriginalData> orderDataList = new List<OrdersOriginalData>();

  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
    });
    var orderList;
    if (LoadingScreenServices.myOrdersList.length == 0) {
      if (Services.isDelivery()) orderList = await OrderServices.getDeliveryOrders(pageNumber: page);
      if (Services.isShopper()) orderList = await OrderServices.getShopperOrders(pageNumber: page);
      if (Services.isSupplierManager()) orderList = await OrderServices.getSupplierOrders(pageNumber: page);
    } else {
      orderList = LoadingScreenServices.myOrdersList;
    }
    if (orderList != null) {
      if (orderList.length == 0) {
        setState(() {
          LoadingScreenServices.myOrdersList = orderDataList;
          if (LoadingScreenServices.myOrdersList.length != 0) theEndOfOrders = true;
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
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: orderDataList == null ? 0 : orderDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          orderDataList[index].orderArithmeticOperations();
                          if (Services.isShopper()) orderDataList[index].orderProfits();
                          if (Services.isSupplierManager())
                            return SupplierOrdersViewCard(
                              order: orderDataList[index],
                            );
                          return Column(
                            children: <Widget>[
                              OrdersViewCard(
                                orderData: orderDataList[index],
                              ),
                              if (!['5', '6', '7'].contains(orderDataList[index].orderStatusId))
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
                                            title: 'ملاحظة العميل',
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
                                            title: "إلغاء التعليق",
                                            text:
                                                "هل أنت متأكد انك تريد إلغاء تعليق الطلب قيامك بهذه العملية قد يلغي التعديلات التي يقوم بها الزبون او شريكك في العمل",
                                            dialogButtons: decisionButtons,
                                            context: context);
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
                                  color: ColorUtils.kmColors2,
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
                            child: ScreenMessage(message: 'لا يوجد أي طلبات سابقة'),
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
      productsQuantity += CartServices.cartProducts[i].productCount.toString() + ";";
    }
    prefs.setString("userCart", productsId + "@" + productsQuantity);

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cartFromUpdate',
      (Route<dynamic> route) => false,
    );
  }
}

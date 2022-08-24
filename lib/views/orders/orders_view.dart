import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';

import '../../core/core_importer.dart';
import 'services/order_services.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrdersViewState();
  }
}

class OrdersViewState extends State<OrdersView> {
  TextEditingController pageController;
  TextEditingController idController;
  TextEditingController phoneController;
  static GlobalKey<FormState> formKey;
  Future getOrders;
  int rateValue;

  @override
  void initState() {
    pageController = TextEditingController();
    phoneController = TextEditingController();
    idController = TextEditingController();
    orderDataList = [];
    formKey = GlobalKey<FormState>();
    warehouses = ['جميع المستودعات'];
    warehouses.addAll(LoadingScreenServices.warehouses.map((warehouse) => warehouse.name).toList());
    rateValue = 0;
    ordersFilter = LoadingScreenServices.ordersViewFilter;
    ordersTypeFilter = 0;
    warehouseFilter = 0;

    if (LoadingScreenServices.allOrdersList.isEmpty) {
      getOrders = _getOrder();
    } else {
      getOrders = _initialFunction();
      orderDataList = LoadingScreenServices.allOrdersList;
    }
    super.initState();
  }

  _initialFunction() {}

  bool orderLoaded = true;
  bool warehouseLoaded = false;
  bool errorMessage = false;
  String errorMessageValue = '';
  bool isLoading = false;
  int page = 1;
  int indexPage = 1;
  bool theEndOfOrders = false;

  int ordersFilter;
  int warehouseFilter;
  int ordersTypeFilter;
  List<String> warehouses;

  List<OrdersOriginalData> orderDataList;

  _getOrder() async {
    setState(() {
      if (indexPage == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
    });
    List<OrdersOriginalData> orderList;
    if (LoadingScreenServices.allOrdersList.isEmpty) {
      orderList = await Services.getAllOrders(pageNumber: indexPage);
    } else {
      orderList = LoadingScreenServices.allOrdersList;
    }

    if (orderList != null) {
      if (orderList.isEmpty) {
        setState(() {
          if (LoadingScreenServices.allOrdersList.isNotEmpty) theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDataList.addAll(orderList);
          if (ordersFilter == 0) {
            orderDataList.removeWhere((order) => int.parse(order.orderStatusId) > 4);
          } else {
            orderDataList.removeWhere((order) => int.parse(order.orderStatusId) != ordersFilter);
          }
          switch (ordersTypeFilter) {
            case (0):
              break;
            case (1):
              orderDataList.removeWhere((order) => order.shopper == null);
              break;
            case (2):
              orderDataList.removeWhere((order) => order.shopper != null);
              break;
          }
          if (warehouseFilter != 0) {
            orderDataList.removeWhere((order) => int.parse(order.warehouseId) != warehouseFilter);
          }

          orderDataList.removeWhere((order) => order.products.isEmpty);
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
        errorMessageValue = 'حدث خطأ اثناء محاولة جلب الطلبات';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
          child: !orderLoaded || isLoading
              ? const Center(child: Loader())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    errorMessage
                        ? AlertMessages(text: errorMessageValue, messageType: 'internetError', headerText: 'حدث خطأ')
                        : Container(),
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
                                  ordersFilter = value;
                                  LoadingScreenServices.ordersViewFilter = value;
                                  page = 1;
                                  indexPage = 1;
                                  pageController.clear();
                                });
                                _getOrder();
                              },
                            ),
                            DropdownButton(
                              value: ordersTypeFilter,
                              items: Services.dropdownStringList(StringUtils.orderTypes),
                              onChanged: (value) {
                                setState(() {
                                  ordersTypeFilter = value;
                                  page = 1;
                                  indexPage = 1;
                                });
                                _getOrder();
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SearchOrderByPhoneNumber(
                                    phoneController: phoneController,
                                    idController: idController,
                                    context: context,
                                    onChoose: () {},
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
                              if (Services.isSuperAdmin())
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DropdownButton(
                                      value: warehouseFilter,
                                      items: Services.dropdownStringList(warehouses),
                                      onChanged: (value) {
                                        setState(() {
                                          warehouseFilter = value;
                                          page = 1;
                                          indexPage = 1;
                                        });
                                        _getOrder();
                                      },
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: EntryField(
                                        edgeInsetsGeometry: EdgeInsets.zero,
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
                                        width: 51,
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    orderDataList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                            child: Center(
                              child: Text(
                                'لا يوجد أي طلبات سابقة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 20.0,
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
                          if (Services.isShopper() || orderDataList[index].shopper != null) {
                            orderDataList[index].orderArithmeticOperations();
                            orderDataList[index].orderProfits();
                          }
                          return Column(
                            children: <Widget>[
                              OrdersViewCard(
                                pop: false,
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
                                        text: orderDataList[index].orderStatusId == '1'
                                            ? 'قبول الطلب'
                                            : orderDataList[index].orderStatusId == '2'
                                                ? 'الطلب جاهز'
                                                : orderDataList[index].orderStatusId == '3'
                                                    ? 'مع التوصيل'
                                                    : 'تم التوصيل',
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        color: orderDataList[index].orderStatusId == '1'
                                            ? Colors.green[700]
                                            : orderDataList[index].orderStatusId == '2'
                                                ? Colors.yellow[700]
                                                : Colors.cyan[700],
                                        onTap: () async {
                                          int changeStatus = 0;
                                          setState(() {
                                            isLoading = true;
                                            errorMessage = false;
                                          });
                                          if (orderDataList[index].orderStatusId == '1') {
                                            changeStatus = 2;
                                          } else if (orderDataList[index].orderStatusId == '2') {
                                            changeStatus = 3;
                                          } else if (orderDataList[index].orderStatusId == '3') {
                                            changeStatus = 4;
                                          } else if (orderDataList[index].orderStatusId == '4') {
                                            changeStatus = 5;
                                          }

                                          bool x = await OrderServices.changeOrderStatusService(
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

                                                bool x = await OrderServices.changeOrderStatusService(
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
                                              context: context,
                                              title: 'رفض الطلب',
                                              text: 'هل أنت متأكد انك تريد رفض الطلب ؟',
                                              dialogButtons: decisionButton);
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

                                                bool x = await OrderServices.changeOrderStatusService(
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
                                              context: context,
                                              title: 'إلغاء الطلب',
                                              text: 'هل أنت متأكد انك تريد إلغاء الطلب ؟',
                                              dialogButtons: decisionButton);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              if (['6', '7'].contains(orderDataList[index].orderStatusId))
                                KammunButton(
                                  text: 'استعادة الطلب',
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

                                          bool result = await OrderServices.changeOrderStatusService(
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
                                        context: context,
                                        title: 'استعادة الطلب',
                                        text: 'هل أنت متأكد انك تريد استعادة الطلب ؟',
                                        dialogButtons: decisionButton);
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
                                  LockOrder response = await OrderServices.lockOrderService(
                                      orderId: orderDataList[index].id.toString(),
                                      userNote: orderDataList[index].userNotes,
                                      supportedCityCost: orderDataList[index].supportedCityCost,
                                      deliveryMethodCost: orderDataList[index].deliveryCost,
                                      deliveryMethodId: int.parse(orderDataList[index].deliveryMethodId.toString()));
                                  if (response != null) {
                                    if (response.success) {
                                      setState(() {
                                        orderLoaded = true;
                                        errorMessage = false;
                                      });
                                      _moveOrderProductsToCart(orderIndex: index, orderProducts: response.products);
                                      orderDataList[index].underUpdate = '1';
                                    } else if (!response.success) {
                                      setState(() {
                                        orderDataList[index].underUpdate = '2';
                                        orderLoaded = true;
                                        errorMessage = true;
                                        errorMessageValue =
                                            'لا يمكنك تعديل طلبك حالياً لأن مسؤول الطلب أو الزبون يقوم بتعديله حالياً';
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      orderLoaded = true;
                                      errorMessage = true;
                                      errorMessageValue =
                                          'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت';
                                    });
                                  }
                                },
                                color: Colors.green,
                              ),
                              orderDataList[index].userNotes.toString() != 'null'
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
                                            context: context,
                                            title: StringUtils.costumerNote,
                                            text: orderDataList[index].userNotes,
                                            dialogButtons: decisionButtons);
                                      },
                                      color: Colors.indigoAccent,
                                    )
                                  : Container(),
                              orderDataList[index].underUpdate.toString() != '0'
                                  ? KammunButton(
                                      text: StringUtils.unLock,
                                      onTap: () {
                                        int orderId = orderDataList[index].id;
                                        List<DialogButton> decisionButtons = [
                                          DialogButton(
                                            text: 'نعم',
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              bool result = await OrderServices.unlockOrderService(orderId.toString());
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
                                            context: context,
                                            title: StringUtils.unLock,
                                            text: StringUtils.unLockConfirm,
                                            dialogButtons: decisionButtons);
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
                                'تم جلب جميع الطلبات',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: StringUtils.fontFamily,
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
    String productsId = '';
    String productsQuantity = '';

    orderProducts.removeWhere((element) => element.pivot.deletedAt != 'null');

    for (int i = 0; i < orderProducts.length; i++) {
      ProductData product = ProductData();

      product.id = orderProducts[i].id;
      product.images = orderProducts[i].images;
      product.name = orderProducts[i].name;

      product.price =
          (int.parse(orderProducts[i].pivot.purchasePrice.split('.')[0]) - orderProducts[i].pivot.increaseValue)
              .toString();

      product.productCount = int.parse(orderProducts[i].pivot.quantity);
      product.unit = orderProducts[i].unit;
      product.quantity = orderProducts[i].quantity;
      product.subWarehouseId = orderProducts[i].subWarehouseId;
      product.pivot = orderProducts[i].pivot;

      CartServices.addProductToCart(product);
    }

    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ';';
      productsQuantity += CartServices.cartProducts[i].productCount.toString() + ';';
    }
    prefs.setString('userCart', productsId + '@' + productsQuantity);

    Navigator.of(context).pushNamedAndRemoveUntil('/cartFromUpdate', (Route<dynamic> route) => false);
  }
}

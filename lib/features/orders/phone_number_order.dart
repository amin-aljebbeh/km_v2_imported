import 'package:kammun_app/features/cart/services/cart_services.dart';

import '../../core/core_importer.dart';
import 'model/change_status_response_model.dart';
import 'services/order_services.dart';

class PhoneNumberOrdersView extends StatefulWidget {
  final String phoneNumber;

  const PhoneNumberOrdersView({Key key, this.phoneNumber}) : super(key: key);

  @override
  _PhoneNumberOrdersViewState createState() => _PhoneNumberOrdersViewState();
}

class _PhoneNumberOrdersViewState extends State<PhoneNumberOrdersView> {
  Future getOrders;
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    filterOrders = 0;
    setState(() => phoneNumber = widget.phoneNumber);
    getOrders = _getOrder();
    orderDataList = LoadingScreenServices.phoneOrderList;
    super.initState();
  }

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageValue = '';
  bool isLoading = false;
  int page = 1;
  bool theEndOfOrders = false;
  String phoneNumber;

  int filterOrders;

  List<OrdersOriginalData> orderDataList = [];

  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
      LoadingScreenServices.phoneOrderList = [];
    });
    List<OrdersOriginalData> orderList;
    LoadingScreenServices.phoneOrderList =
        await OrderServices.getOrdersByUserNumberService(phoneNumber: phoneNumber, pageNumber: page);
    orderList = LoadingScreenServices.phoneOrderList;

    if (orderList != null) {
      if (orderList.isEmpty) {
        setState(() {
          if (LoadingScreenServices.phoneOrderList.isNotEmpty) theEndOfOrders = true;
          orderLoaded = true;
          errorMessage = false;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDataList = orderList;
          if (filterOrders != 0) {
            if (filterOrders == 1) {
              orderDataList.removeWhere((order) => int.parse(order.orderStatusId) > 4);
            } else {
              orderDataList.removeWhere((order) => int.parse(order.orderStatusId) != filterOrders - 1);
            }
          }

          orderDataList.removeWhere((order) => order.products.isEmpty);
          LoadingScreenServices.phoneOrderList = orderDataList;
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
    final double screenHeight = MediaQuery.of(context).size.height;
    return TemporaryLoading(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              errorMessage
                  ? AlertMessages(text: errorMessageValue, messageType: 'internetError', headerText: 'حدث خطأ')
                  : Container(padding: EdgeInsets.zero),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton(
                    value: filterOrders,
                    items: Services.dropdownStringList(phoneOrderStatus),
                    onChanged: (value) {
                      setState(() {
                        filterOrders = value;
                        page = 1;
                      });
                      _getOrder();
                    },
                  ),
                  SearchOrderByPhoneNumber(
                    phoneController: phoneController,
                    idController: idController,
                    context: context,
                    onChoose: () => Navigator.of(context).pop(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: IconButton(
                      onPressed: () {
                        if (page < 14) setState(() => page++);

                        _getOrder();
                      },
                      icon: Icon(Icons.arrow_back, size: 40, color: kmColors),
                    ),
                  ),
                  DropdownButton(
                    value: page,
                    items: Services.dropdownIntList(inputList: dropdownValues),
                    onChanged: (value) {
                      setState(() => page = value);
                      _getOrder();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: IconButton(
                      onPressed: () => setState(() {
                        if (page > 1) page--;
                        _getOrder();
                      }),
                      icon: Icon(Icons.arrow_forward, size: 40, color: kmColors),
                    ),
                  ),
                ],
              ),
              !orderLoaded || isLoading
                  ? const Center(child: Loader())
                  : orderDataList.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.4),
                          child: Center(
                            child: Text(
                              'لا يوجد أي طلبات سابقة',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: greyColor,
                                fontFamily: fontFamily,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        )
                      : Container(padding: EdgeInsets.zero),
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
                        OrdersViewCard(pop: true, orderData: orderDataList[index], orderType: OrderTypes.search),
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

                                    ChangeOrderStatusModel x = await OrderServices.changeOrderStatusService(
                                        orderDataList[index].id.toString(), changeStatus);

                                    if (x.success) {
                                      setState(() {
                                        orderDataList[index] = x.order;
                                        LoadingScreenServices.phoneOrderList[index] = x.order;
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

                                          ChangeOrderStatusModel x = await OrderServices.changeOrderStatusService(
                                              orderDataList[index].id.toString(), changeStatus);

                                          if (x.success) {
                                            setState(() {
                                              orderDataList[index] = x.order;
                                              LoadingScreenServices.phoneOrderList[index] = x.order;
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
                                      DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                                    ];
                                    showMyDialog(
                                        context: context,
                                        title: 'رفض الطلب',
                                        text: 'هل أنت متأكد انك تريد رفض الطلب ؟',
                                        dialogButtons: decisionButton);
                                  },
                                  text: cancelOrder,
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

                                          ChangeOrderStatusModel x = await OrderServices.changeOrderStatusService(
                                              orderDataList[index].id.toString(), changeStatus);

                                          if (x.success) {
                                            setState(() {
                                              orderDataList[index] = x.order;
                                              LoadingScreenServices.phoneOrderList[index] = x.order;
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
                                      DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
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
                            color: kmColors,
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

                                    ChangeOrderStatusModel result = await OrderServices.changeOrderStatusService(
                                        orderDataList[index].id.toString(), changeStatus);
                                    if (result.success) {
                                      snackBar(success: true, message: 'تم تغيير حالة الطلب بنجاح', context: context);
                                      orderDataList[index] = result.order;
                                      LoadingScreenServices.phoneOrderList[index] = result.order;
                                    } else {
                                      snackBar(
                                          success: false,
                                          message: 'فشلت عملية تغيير حالة الطلب يرجى المحاولة مجدداً',
                                          context: context);
                                    }

                                    if (result.success) {
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
                                DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                              ];
                              showMyDialog(
                                  context: context,
                                  title: 'استعادة الطلب',
                                  text: 'هل أنت متأكد انك تريد استعادة الطلب ؟',
                                  dialogButtons: decisionButton);
                            },
                          ),
                        KammunButton(
                          text: editOrder,
                          onTap: () async {
                            setState(() {
                              orderLoaded = false;
                              errorMessage = false;
                            });
                            LockOrder response = await OrderServices.lockOrderService(
                                orderId: orderDataList[index].id.toString(),
                                userNote: orderDataList[index].userNotes,
                                supportedCityCost: orderDataList[index].supportedCityCost,
                                deliveryMethodCost: orderDataList[index].deliveryCost,
                                deliveryMethodId: int.parse(orderDataList[index].deliveryMethodId.toString()));
                            if (response != null) {
                              if (response.success) {
                                setState(() {
                                  OrderServices.orderUnderUpdateStatusId = orderDataList[index].orderStatusId;
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
                                errorMessageValue = 'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت';
                              });
                            }
                          },
                          color: Colors.green,
                        ),
                        orderDataList[index].userNotes.toString() != 'null'
                            ? KammunButton(
                                text: watchNote,
                                onTap: () {
                                  showMyDialog(
                                      context: context,
                                      title: costumerNote,
                                      text: orderDataList[index].userNotes,
                                      dialogButtons: [const CloseWidget()]);
                                },
                                color: Colors.indigoAccent,
                              )
                            : Container(),
                        orderDataList[index].underUpdate.toString() != '0'
                            ? KammunButton(
                                text: unLock,
                                onTap: () {
                                  int orderId = orderDataList[index].id;
                                  List<Widget> decisionButtons = [
                                    DialogButton(
                                      text: 'نعم',
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        bool result = await OrderServices.unlockOrderService(orderId.toString());
                                        if (result) {
                                          snackBar(
                                              success: true, message: 'نجحت عملية إلغاء تعليق الطلب', context: context);
                                        } else {
                                          snackBar(
                                              success: false,
                                              message: 'فشلت عملية إلغاء تعليق الطلب يرجى المحاولة مجدداً',
                                              context: context);
                                        }
                                        if (result) setState(() => orderDataList[index].underUpdate = '0');
                                      },
                                    ),
                                    const CloseWidget()
                                  ];
                                  showMyDialog(
                                      context: context,
                                      title: unLock,
                                      text: unLockConfirm,
                                      dialogButtons: decisionButtons);
                                },
                                color: Colors.blue[800],
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Divider(thickness: 5, color: kmColors2),
                        )
                      ],
                    );
                  },
                ),
              ),
              theEndOfOrders
                  ? Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.4),
                      child: const ScreenMessage(message: 'لا يوجد أي طلبات سابقة'),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    ));
  }

  _moveOrderProductsToCart({int orderIndex, List<OrderProduct> orderProducts}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartServices.cartProducts.clear();
    String productsId = '';
    String productsQuantity = '';

    for (int i = 0; i < orderProducts.length; i++) {
      if (orderProducts[i].pivot.deletedAt == 'null') {
        ProductData product = ProductData();

        product.id = orderProducts[i].id;
        product.images = orderProducts[i].images;
        product.name = orderProducts[i].name;
        product.pivot = OrderProductPivot(
            subWarehouseId: orderProducts[i].pivot.subWarehouseId,
            quantity: orderProducts[i].pivot.quantity,
            increaseValue: orderProducts[i].pivot.increaseValue,
            purchasePrice: orderProducts[i].pivot.purchasePrice);
        product.price =
            (int.parse(orderProducts[i].pivot.purchasePrice.split('.')[0]) - orderProducts[i].pivot.increaseValue)
                .toString();

        product.productCount = int.parse(orderProducts[i].pivot.quantity);
        product.unit = orderProducts[i].unit;
        product.quantity = orderProducts[i].quantity;
        product.subWarehouseId = orderProducts[i].subWarehouseId;
        CartServices.addProductToCart(product);
      }
    }

    for (int i = 0; i < CartServices.cartProducts.length; i++) {
      productsId += CartServices.cartProducts[i].id.toString() + ';';
      productsQuantity += CartServices.cartProducts[i].productCount.toString() + ';';
    }
    prefs.setString('userCart', productsId + '@' + productsQuantity);

    Navigator.of(context).pushNamedAndRemoveUntil(CartView.fromUpdateRouteName, (Route<dynamic> route) => false);
  }
}

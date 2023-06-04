import 'package:kammun_app/features/cart/services/cart_services.dart';

import '../../../core/core_importer.dart';
import '../model/change_status_response_model.dart';
import '../services/order_services.dart';

class AssignedOrdersView extends StatefulWidget {
  const AssignedOrdersView({Key key}) : super(key: key);

  @override
  _AssignedOrdersViewState createState() => _AssignedOrdersViewState();
}

class _AssignedOrdersViewState extends State<AssignedOrdersView> {
  Future getOrders;

  @override
  void initState() {
    filterOrders = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (StaticVariables.myOrdersList.isEmpty) {
        getOrders = _getOrder();
      } else {
        orderDataList = StaticVariables.myOrdersList;
      }
    });

    super.initState();
  }

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageValue = '';
  bool isLoading = false;
  int page = 1;
  bool theEndOfOrders = false;

  int filterOrders;

  List<OrdersOriginalData> orderDataList = [];

  _getOrder() async {
    ApiProvider.cancelOrdersRequests();
    try {
      setState(() {
        if (page == 1) orderLoaded = false;
        if (!theEndOfOrders) isLoading = true;
        errorMessage = false;
        orderDataList.clear();
      });
      List<OrdersOriginalData> orderList;
      if (StaticVariables.myOrdersList.isEmpty) {
        if (Services.hasRole(context, shopperRole)) orderList = await OrderServices.getShopperOrders(pageNumber: page);
        if (Services.hasRole(context, supplierRole)) {
          orderList = await OrderServices.getSupplierOrders(pageNumber: page);
        }
      } else {
        orderList = StaticVariables.myOrdersList;
      }
      if (orderList != null) {
        if (orderList.isEmpty) {
          setState(() {
            StaticVariables.myOrdersList = orderDataList;
            if (StaticVariables.myOrdersList.isNotEmpty) theEndOfOrders = true;
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

            orderDataList.removeWhere((order) => order.products.isEmpty);
            StaticVariables.myOrdersList = orderDataList;
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
    } catch (e) {
      //
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
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
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
                            child: Text('لا يوجد أي طلبات سابقة',
                                style: mainStyle.copyWith(
                                    fontWeight: FontWeight.w700, color: primaryColor, fontSize: 20.0)),
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
                    OrdersOriginalData otherOrder = orderDataList.firstWhere(
                        (order) => order.id != orderDataList[index].id && order.userId == orderDataList[index].userId,
                        orElse: () => OrdersOriginalData(orderStatusId: '5'));
                    bool cancelOrderCondition = int.parse(otherOrder.orderStatusId) <= 4;
                    orderDataList[index].orderArithmeticOperations();
                    if (!Services.hasRole(context, supplierRole)) orderDataList[index].orderProfits(context: context);
                    if (Services.hasRole(context, supplierRole)) {
                      return SupplierOrdersViewCard(order: orderDataList[index]);
                    }
                    return Column(
                      children: <Widget>[
                        OrdersViewCard(pop: false, order: orderDataList[index], orderType: OrderTypes.myOrder),
                        (isLoading)
                            ? const Loader()
                            : Column(
                                children: [
                                  if (int.parse(orderDataList[index].orderStatusId) <= 4 &&
                                      int.parse(orderDataList[index].underUpdate) != 1)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: KammunButton(
                                              text: orderDataList[index].orderStatusId == '1'
                                                  ? 'قبول الطلب'
                                                  : orderDataList[index].orderStatusId == '2'
                                                      ? 'الطلب جاهز'
                                                      : orderDataList[index].orderStatusId == '3'
                                                          ? 'مع التوصيل'
                                                          : 'تم التوصيل',
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
                                                    StaticVariables.myOrdersList[index] = x.order;
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
                                          ),
                                        ),
                                        if (cancelOrderCondition)
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2),
                                              child: KammunButton(
                                                text: cancelOrder,
                                                color: Colors.red,
                                                onTap: () {
                                                  showMyDialog(
                                                      context: context,
                                                      title: 'إلغاء الطلب',
                                                      text: 'هل أنت متأكد انك تريد إلغاء الطلب ؟',
                                                      dialogButtons: [
                                                        DialogButton(
                                                          text: 'نعم',
                                                          onTap: () async {
                                                            int changeStatus = 0;
                                                            Navigator.of(context).pop();
                                                            setState(() => {isLoading = true, errorMessage = false});
                                                            changeStatus = 6;
                                                            ChangeOrderStatusModel x =
                                                                await OrderServices.changeOrderStatusService(
                                                                    orderDataList[index].id.toString(), changeStatus);
                                                            if (x.success) {
                                                              setState(() {
                                                                orderDataList[index] = x.order;
                                                                StaticVariables.myOrdersList[index] = x.order;
                                                                isLoading = false;
                                                              });
                                                            } else {
                                                              setState(() => {isLoading = false, errorMessage = true});
                                                            }
                                                          },
                                                        ),
                                                        DialogButton(
                                                            text: no, onTap: () => Navigator.of(context).pop()),
                                                      ]);
                                                },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  if (!['5', '6', '7'].contains(orderDataList[index].orderStatusId))
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
                                            deliveryMethodCost: orderDataList[index].deliveryCost);
                                        if (response != null) {
                                          if (response.success) {
                                            setState(() {
                                              OrderServices.orderUnderUpdateStatusId =
                                                  orderDataList[index].orderStatusId;
                                              orderLoaded = true;
                                              errorMessage = false;
                                            });
                                            _moveOrderProductsToCart(
                                                orderIndex: index, orderProducts: response.products);
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
                                  if (orderDataList[index].userNotes.toString() != 'null')
                                    KammunButton(
                                      text: watchNote,
                                      onTap: () {
                                        showMyDialog(
                                            context: context,
                                            title: 'ملاحظة العميل',
                                            text: orderDataList[index].userNotes,
                                            dialogButtons: [const CloseWidget()]);
                                      },
                                      color: Colors.indigoAccent,
                                    ),
                                  if (orderDataList[index].underUpdate.toString() != '0')
                                    KammunButton(
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
                                                    success: result, message: 'تم تعليق الطلب بنجاح', context: context);
                                              } else {
                                                snackBar(
                                                    success: result,
                                                    message: 'فشلت عملية تعليق الطلب يرجى المحاولة مجدداً',
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
                                    ),
                                ],
                              ),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0), child: Divider(thickness: 5, color: kmColors2))
                      ],
                    );
                  },
                ),
              ),
              if (theEndOfOrders)
                Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.4),
                    child: const ScreenMessage(message: 'لا يوجد أي طلبات سابقة')),
            ],
          ),
        ),
      ),
    );
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
        product.subWarehouseId = orderProducts[i].pivot.subWarehouseId ?? -1;
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

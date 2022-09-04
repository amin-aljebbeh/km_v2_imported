import 'package:kammun_app/views/cart/services/cart_services.dart';

import '../../core/core_importer.dart';
import '../loading/loading_services.dart';
import 'services/order_services.dart';

class OrderByID extends StatefulWidget {
  final String id;

  const OrderByID({Key key, this.id}) : super(key: key);

  @override
  _OrderByIDState createState() => _OrderByIDState();
}

class _OrderByIDState extends State<OrderByID> {
  Future getOrders;
  OrdersOriginalData order;
  TextEditingController idController;
  TextEditingController phoneController;
  @override
  void initState() {
    phoneController = TextEditingController();
    idController = TextEditingController();
    id = widget.id;
    getOrders = _getOrder();

    super.initState();
  }

  bool orderLoaded = true;
  bool errorMessage = false;
  String errorMessageValue = '';
  bool isLoading = false;
  bool theEndOfOrders = false;
  String id;

  _getOrder() async {
    setState(() {
      orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
    });
    OrdersOriginalData orderList;
    orderList = (await OrderServices.getOrder(orderId: id)).order;

    if (orderList != null) {
      order = orderList;
      LoadingScreenServices.phoneOrderList = [order];
      if (Services.isShopper() || order.shopper != null) {
        order.orderArithmeticOperations();
        order.orderProfits();
      }
      setState(() {
        orderLoaded = true;
        errorMessage = false;
        isLoading = false;
      });
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
                        : Container(padding: EdgeInsets.zero),
                    Center(
                      child: SearchOrderByPhoneNumber(
                          phoneController: phoneController,
                          idController: idController,
                          context: context,
                          onChoose: () => Navigator.of(context).pop()),
                    ),
                    Column(
                      children: <Widget>[
                        OrdersViewCard(pop: true, orderData: order, orderType: OrderTypes.search),
                        if (int.parse(order.orderStatusId) <= 4 && int.parse(order.underUpdate) != 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KammunButton(
                                  text: order.orderStatusId == '1'
                                      ? 'قبول الطلب'
                                      : order.orderStatusId == '2'
                                          ? 'الطلب جاهز'
                                          : order.orderStatusId == '3'
                                              ? 'مع التوصيل'
                                              : 'تم التوصيل',
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  color: order.orderStatusId == '1'
                                      ? Colors.green[700]
                                      : order.orderStatusId == '2'
                                          ? Colors.yellow[700]
                                          : Colors.cyan[700],
                                  onTap: () async {
                                    int changeStatus = 0;
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = false;
                                    });
                                    if (order.orderStatusId == '1') {
                                      changeStatus = 2;
                                    } else if (order.orderStatusId == '2') {
                                      changeStatus = 3;
                                    } else if (order.orderStatusId == '3') {
                                      changeStatus = 4;
                                    } else if (order.orderStatusId == '4') {
                                      changeStatus = 5;
                                    }

                                    bool x =
                                        await OrderServices.changeOrderStatusService(order.id.toString(), changeStatus);

                                    if (x) {
                                      setState(() {
                                        order.orderStatusId = changeStatus.toString();
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
                                              order.id.toString(), changeStatus);

                                          if (x) {
                                            setState(() {
                                              order.orderStatusId = changeStatus.toString();
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

                                          bool x = await OrderServices.changeOrderStatusService(
                                              order.id.toString(), changeStatus);

                                          if (x) {
                                            setState(() {
                                              order.orderStatusId = changeStatus.toString();
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
                        if (['6', '7'].contains(order.orderStatusId))
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

                                    bool result =
                                        await OrderServices.changeOrderStatusService(order.id.toString(), changeStatus);
                                    Services.resultFlushBar(context: context, result: result);

                                    if (result) {
                                      setState(() {
                                        order.orderStatusId = changeStatus.toString();
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
                                orderId: order.id.toString(),
                                userNote: order.userNotes,
                                supportedCityCost: order.supportedCityCost,
                                deliveryMethodCost: order.deliveryCost,
                                deliveryMethodId: int.parse(order.deliveryMethodId.toString()));
                            if (response != null) {
                              if (response.success) {
                                setState(() {
                                  OrderServices.orderUnderUpdateStatusId = order.orderStatusId;
                                  orderLoaded = true;
                                  errorMessage = false;
                                });
                                _moveOrderProductsToCart(orderProducts: response.products);
                                order.underUpdate = '1';
                              } else if (!response.success) {
                                setState(() {
                                  order.underUpdate = '2';
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
                        order.userNotes.toString() != 'null'
                            ? KammunButton(
                                text: watchNote,
                                onTap: () => showMyDialog(
                                    context: context,
                                    title: costumerNote,
                                    text: order.userNotes,
                                    dialogButtons: [const CloseWidget()]),
                                color: Colors.indigoAccent,
                              )
                            : Container(),
                        order.underUpdate.toString() != '0'
                            ? KammunButton(
                                text: unLock,
                                onTap: () {
                                  int orderId = order.id;
                                  List<Widget> decisionButtons = [
                                    DialogButton(
                                      text: 'نعم',
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        bool result = await OrderServices.unlockOrderService(orderId.toString());
                                        Services.resultFlushBar(context: context, result: result);
                                        setState(() {
                                          if (result) order.underUpdate = '0';
                                        });
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
    );
  }

  _moveOrderProductsToCart({List<OrderProduct> orderProducts}) async {
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

        product.price = orderProducts[i].pivot.purchasePrice;

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
    LoadingScreenServices.phoneOrderList = [order];
    Navigator.of(context).pushNamedAndRemoveUntil(CartView.fromUpdateRouteName, (Route<dynamic> route) => false);
  }
}

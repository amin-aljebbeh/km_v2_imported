import 'package:kammun_app/views/cart/services/cart_services.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import '../../core/core_importer.dart';
import 'services/order_services.dart';

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

    if (LoadingScreenServices.myOrdersList.isEmpty) {
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
  String errorMessageValue = '';
  bool isLoading = false;
  int page = 1;
  bool theEndOfOrders = false;

  int filterOrders;

  List<OrdersOriginalData> orderDataList = [];

  _getOrder() async {
    setState(() {
      if (page == 1) orderLoaded = false;
      if (!theEndOfOrders) isLoading = true;
      errorMessage = false;
      orderDataList.clear();
    });
    List<OrdersOriginalData> orderList;
    if (LoadingScreenServices.myOrdersList.isEmpty) {
      if (Services.isShopper()) orderList = await OrderServices.getShopperOrders(pageNumber: page);
      if (Services.isSupplierManager()) orderList = await OrderServices.getSupplierOrders(pageNumber: page);
    } else {
      orderList = LoadingScreenServices.myOrdersList;
    }
    if (orderList != null) {
      if (orderList.isEmpty) {
        setState(() {
          LoadingScreenServices.myOrdersList = orderDataList;
          if (LoadingScreenServices.myOrdersList.isNotEmpty) theEndOfOrders = true;
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
          padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
          child: !orderLoaded || isLoading
              ? const Center(child: Loader())
              : Column(
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
                          items: Services.dropdownIntList(dropdownValues),
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
                    orderDataList.isEmpty
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
                          orderDataList[index].orderArithmeticOperations();
                          if (!Services.isSupplierManager()) orderDataList[index].orderProfits();
                          if (Services.isSupplierManager()) return SupplierOrdersViewCard(order: orderDataList[index]);
                          return Column(
                            children: <Widget>[
                              OrdersViewCard(
                                  pop: false, orderData: orderDataList[index], orderType: OrderTypes.myOrder),
                              if (int.parse(orderDataList[index].orderStatusId) <= 4 &&
                                  int.parse(orderDataList[index].underUpdate) != 1)
                                KammunButton(
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
                                        errorMessageValue =
                                            'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت';
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
                                            title: 'ملاحظة العميل',
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
                                              Services.resultFlushBar(context: context, result: result);
                                              setState(() {
                                                if (result) orderDataList[index].underUpdate = '0';
                                              });
                                            },
                                          ),
                                          const CloseWidget()
                                        ];

                                        showMyDialog(
                                            context: context,
                                            title: 'إلغاء التعليق',
                                            text:
                                                'هل أنت متأكد انك تريد إلغاء تعليق الطلب قيامك بهذه العملية قد يلغي التعديلات التي يقوم بها الزبون او شريكك في العمل',
                                            dialogButtons: decisionButtons);
                                      },
                                      color: Colors.blue[800],
                                    )
                                  : Container(),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Divider(thickness: 5, color: kmColors2))
                            ],
                          );
                        },
                      ),
                    ),
                    theEndOfOrders
                        ? Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.4),
                            child: const ScreenMessage(message: 'لا يوجد أي طلبات سابقة'))
                        : Container(),
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

        product.price =
            (int.parse(orderProducts[i].pivot.purchasePrice.split('.')[0]) - orderProducts[i].pivot.increaseValue)
                .toString();

        product.productCount = int.parse(orderProducts[i].pivot.quantity);
        product.unit = orderProducts[i].unit;
        product.quantity = orderProducts[i].quantity;
        product.subWarehouseId = orderProducts[i].pivot.subWarehouseId;
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

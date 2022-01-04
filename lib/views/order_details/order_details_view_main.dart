import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/common_utils.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/utils/Loader.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class OrderDetailViewMain extends StatefulWidget {
  List<OrderProducts> ordersAry;
  int subTotal;
  String total;
  String deliveryPrice;
  int orderId;
  String addressName;
  OrdersOriginalData order;
  final OrderType orderType;

  OrderDetailViewMain(
      {this.ordersAry,
      this.subTotal,
      this.total,
      this.deliveryPrice,
      this.orderId,
      this.addressName,
      this.order,
      @required this.orderType});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewMainState();
  }
}

class OrderDetailViewMainState extends State<OrderDetailViewMain> {
  static List<OrderProducts> productsAry;
  static List<OrderProducts> deletedProductsAry;
  static List<OrderProducts> notDeletedProductsAry;
  static List<OrderProducts> finalProductsAry;

  String subTotal() {
    int total = 0;
    if (Services.isSupplierManager()) {
      total = Services.productsNetPrice(widget.ordersAry, widget.order.id);
    } else {
      total = widget.subTotal;
    }
    return StringUtils().oCcy.format(total).toString() +
        " ${LoadingScreenServices.companyInformation.currency}";
  }

  @override
  void initState() {
    super.initState();

    try {
      setState(() {
        productsAry = widget.ordersAry;
        idOrder = widget.orderId;

        if (LoadingScreenServices.subWarehouses.length == 1) {
          productsAry.sort((a, b) {
            if (a.subWarehouseId > b.subWarehouseId) {
              return -1;
            } else if (a.subWarehouseId < b.subWarehouseId) {
              return 1;
            } else
              return 0;
          });
        } else {
          productsAry.sort((a, b) {
            if (a.subWarehouseId > b.subWarehouseId) {
              return 1;
            } else if (a.subWarehouseId < b.subWarehouseId) {
              return -1;
            } else
              return 0;
          });
        }
      });
      deletedProductsAry = List<OrderProducts>();
      notDeletedProductsAry = List<OrderProducts>();
      finalProductsAry = List<OrderProducts>();
      for (int i = 0; i < productsAry.length; i++)
        if (productsAry[i].pivot.deletedAt != null)
          deletedProductsAry.add(productsAry[i]);
        else
          notDeletedProductsAry.add(productsAry[i]);
      if (notDeletedProductsAry.length != 0)
        finalProductsAry.addAll(notDeletedProductsAry);
      if (deletedProductsAry.length != 0)
        finalProductsAry.addAll(deletedProductsAry);
    } catch (e) {}
  }

  _refillProducts() {
    setState(() {
      productsAry = widget.ordersAry;
      idOrder = widget.orderId;

      if (LoadingScreenServices.subWarehouses.length == 1) {
        productsAry.sort((a, b) {
          if (a.subWarehouseId > b.subWarehouseId) {
            return -1;
          } else if (a.subWarehouseId < b.subWarehouseId) {
            return 1;
          } else
            return 0;
        });
      } else {
        productsAry.sort((a, b) {
          if (a.subWarehouseId > b.subWarehouseId) {
            return 1;
          } else if (a.subWarehouseId < b.subWarehouseId) {
            return -1;
          } else
            return 0;
        });
      }
    });
  }

  int idOrder;
  bool isLoading = false;
  bool errorAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
          child: isLoading
              ? Center(child: Loader())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                color: Theme.of(context).primaryColorDark,
                                size: 45),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: !Services.isSupplierManager()
                              ? AutoSizeText(
                                  widget.addressName.length > 37
                                      ? widget.addressName.substring(0, 37)
                                      : widget.addressName,
                                  maxLines: 1,

                                  // maxFontSize: 20,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  ),
                                )
                              : Text(
                                  widget.orderId.toString().length >= 3
                                      ? "#${widget.orderId.toString().substring(2, widget.orderId.toString().length)}"
                                      : '#${widget.orderId.toString()}',
                                  style: profitStyle.copyWith(
                                    color: Colors.purple,
                                  ),
                                ),
                        ),
                        IconButton(
                            icon: Icon(Icons.refresh,
                                color: Theme.of(context).primaryColor,
                                size: 30),
                            onPressed: () {
                              _refillProducts();
                            }),
                      ],
                    ),
                    errorAlert
                        ? AlertMessages(
                            text: "خطأ اثناء محاولة تغيير حالة الطلب",
                            messageType: "internetError",
                            headerText: "حدث خطأ",
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: productsAry == null ? 1 : productsAry.length,
                        itemBuilder: (BuildContext context, int index) {
                          OrderProducts orderDetail = finalProductsAry[index];
                          if (index < notDeletedProductsAry.length) {
                            return new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => {},
                              child: OrderDetailViewMainCard(
                                increaseValue: orderDetail.pivot.increaseValue,
                                subWarehouseId: orderDetail.subWarehouseId,
                                orderId: widget.orderId,
                                onCheckbox: (a) {
                                  setState(() {
                                    switch (widget.orderType) {
                                      case OrderType.myOrder:
                                        LoadingScreenServices.myOrdersList
                                            .firstWhere((order) =>
                                                order.id == widget.orderId)
                                            .products
                                            .removeWhere((product) =>
                                                product.id ==
                                                notDeletedProductsAry[a].id);
                                        break;
                                      case OrderType.allOrder:
                                        LoadingScreenServices.allOrdersList
                                            .firstWhere((order) =>
                                                order.id == widget.orderId)
                                            .products
                                            .removeWhere((product) =>
                                                product.id ==
                                                notDeletedProductsAry[a].id);
                                        break;
                                      case OrderType.orders:
                                        LoadingScreenServices
                                            .notAssignedOrdersList
                                            .firstWhere((order) =>
                                                order.id == widget.orderId)
                                            .products
                                            .removeWhere((product) =>
                                                product.id ==
                                                notDeletedProductsAry[a].id);
                                        break;
                                    }
                                    notDeletedProductsAry.removeAt(a);
                                    finalProductsAry.removeAt(index);
                                  });
                                },
                                productsData: orderDetail,
                                supplierCode: orderDetail.supplierCode,
                                active: orderDetail.isActive,
                                productId: orderDetail.pivot.productId,
                                img: orderDetail.images.length != 0
                                    ? LoadingScreenServices.imagePrefixUrl +
                                        orderDetail.images[0].imageFileName
                                    : "",
                                productName: orderDetail.name,
                                quantity: orderDetail.quantity,
                                price:
                                    int.parse(orderDetail.pivot.purchasePrice),
                                unit: orderDetail.unit == null
                                    ? ""
                                    : orderDetail.unit,
                                productCount:
                                    orderDetail.pivot.quantity.toString(),
                                index: index,
                              ),
                            );
                          }
                          if (Services.isAdmin())
                            return new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => {},
                              child: BlurredWidget(
                                child: OrderDetailViewMainCard(
                                  increaseValue:
                                      orderDetail.pivot.increaseValue,
                                  subWarehouseId: orderDetail.subWarehouseId,
                                  orderId: widget.orderId,
                                  onCheckbox: (a) {
                                    if (Services.isShopper())
                                      setState(() {
                                        LoadingScreenServices.myOrdersList
                                            .firstWhere((order) =>
                                                order.id == widget.orderId)
                                            .products
                                            .removeWhere((product) =>
                                                product.id ==
                                                deletedProductsAry[a].id);
                                        deletedProductsAry.removeAt(a);
                                        finalProductsAry.removeAt(index);
                                      });
                                  },
                                  productsData: orderDetail,
                                  supplierCode: orderDetail.supplierCode,
                                  active: orderDetail.isActive,
                                  productId: orderDetail.pivot.productId,
                                  img: orderDetail.images.length != 0
                                      ? LoadingScreenServices.imagePrefixUrl +
                                          orderDetail.images[0].imageFileName
                                      : "",
                                  productName: orderDetail.name,
                                  quantity: orderDetail.quantity,
                                  price: int.parse(
                                      orderDetail.pivot.purchasePrice),
                                  unit: orderDetail.unit == null
                                      ? ""
                                      : orderDetail.unit,
                                  productCount:
                                      orderDetail.pivot.quantity.toString(),
                                  index:
                                      index - (deletedProductsAry.length + 1),
                                ),
                              ),
                            );
                          return Container();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            StringUtils.subtotal,
                            style: darkBold,
                          ),
                          Text(
                            subTotal(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: StringUtils.fontFamilyHKGrotesk,
                                fontSize: 17.0),
                          ),
                        ],
                      ),
                    ),
                    Services.isSupplierManager()
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(StringUtils.total,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontFamily:
                                              StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 19.0,
                                        )),
                                    Text(
                                      "${StringUtils().oCcy.format(int.parse(widget.total))}" +
                                          " ${LoadingScreenServices.companyInformation.currency}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontFamily:
                                              StringUtils.fontFamilyHKGrotesk,
                                          fontSize: 19),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              int.parse(widget.order.orderStatusId) <= 4 &&
                                      int.parse(widget.order.underUpdate) != 1
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          KammunButton(
                                            text: widget.order.orderStatusId ==
                                                    "1"
                                                ? "قبول الطلب"
                                                : widget.order.orderStatusId ==
                                                        "2"
                                                    ? "الطلب جاهز"
                                                    : widget.order
                                                                .orderStatusId ==
                                                            "3"
                                                        ? "مع التوصيل"
                                                        : "تم التوصيل",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            color: widget.order.orderStatusId ==
                                                    "1"
                                                ? Colors.green[700]
                                                : widget.order.orderStatusId ==
                                                        "2"
                                                    ? Colors.yellow[700]
                                                    : Colors.cyan[700],
                                            onTap: () async {
                                              int changeStatus = 0;
                                              setState(() {
                                                isLoading = true;
                                                errorAlert = false;
                                              });
                                              if (widget.order.orderStatusId ==
                                                  "1")
                                                changeStatus = 2;
                                              else if (widget
                                                      .order.orderStatusId ==
                                                  "2")
                                                changeStatus = 3;
                                              else if (widget
                                                      .order.orderStatusId ==
                                                  "3")
                                                changeStatus = 4;
                                              else if (widget
                                                      .order.orderStatusId ==
                                                  "4") changeStatus = 5;

                                              bool x = await OrderServices
                                                  .changeOrderStatus(
                                                      widget.orderId.toString(),
                                                      changeStatus);

                                              if (x) {
                                                setState(() {
                                                  widget.order.orderStatusId =
                                                      changeStatus.toString();
                                                  isLoading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  isLoading = false;
                                                  errorAlert = true;
                                                });
                                              }
                                            },
                                          ),
                                          // _showCancelButton(idOrder),
                                          KammunButton(
                                            text: "إلغاء الطلب",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            color: Colors.red,
                                            onTap: () {
                                              List<DialogButton>
                                                  decisionButton = [
                                                DialogButton(
                                                  text: 'نعم',
                                                  onTap: () async {
                                                    int changeStatus = 0;
                                                    Navigator.of(context).pop();

                                                    setState(() {
                                                      isLoading = true;
                                                      errorAlert = false;
                                                    });
                                                    changeStatus = 6;

                                                    bool x = await OrderServices
                                                        .changeOrderStatus(
                                                            widget.orderId
                                                                .toString(),
                                                            changeStatus);

                                                    if (x) {
                                                      setState(() {
                                                        widget.order
                                                                .orderStatusId =
                                                            changeStatus
                                                                .toString();
                                                        isLoading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                        errorAlert = true;
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
                                                  title: "إلغاء الطلب",
                                                  text:
                                                      "هل أنت متأكد انك تريد إلغاء الطلب ؟",
                                                  dialogButtons: decisionButton,
                                                  context: context);
                                            },
                                          ),
                                          // _showCancelOrderButton(idOrder),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }
}

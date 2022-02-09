import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/orders/services/order_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class OrderDetailViewMain extends StatefulWidget {
  int subTotal;
  double remaining;
  double totalDiscount;
  String total;
  OrdersOriginalData order;
  final OrderTypes orderType;

  OrderDetailViewMain({
    this.subTotal,
    this.total,
    this.order,
    @required this.orderType,
    this.remaining,
    this.totalDiscount,
  });

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewMainState();
  }
}

class OrderDetailViewMainState extends State<OrderDetailViewMain>
    with AutomaticKeepAliveClientMixin<OrderDetailViewMain> {
  static List<OrderProducts> productsAry;
  getArray() {
    productsAry = List<OrderProducts>();
    productsAry.addAll(widget.order.products);
    productsAry.removeWhere((product) => product.pivot.deletedAt != 'null');

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
  }

  @override
  void initState() {
    super.initState();
    getArray();
  }

  bool isLoading = false;
  bool errorAlert = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    getArray();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: EdgeInsets.only(left: 0, top: 0, right: 20, bottom: 10),
        child: isLoading
            ? Center(child: Loader())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                        OrderProducts productDetail = productsAry[index];
                        return Column(
                          children: [
                            if (newSubWarehouse(index))
                              Column(
                                children: [
                                  Divider(
                                    thickness: 5,
                                    color: ColorUtils.primaryColor,
                                  ),
                                  Container(
                                    color: ColorUtils.searchGreyColor,
                                    child: Center(
                                      child: Text(
                                        LoadingScreenServices.subWarehouses
                                            .firstWhere(
                                                (subWarehouse) => subWarehouse.id == productDetail.subWarehouseId)
                                            .name,
                                        style: warehouseStyle,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                  ),
                                ],
                              ),
                            OrderDetailViewMainCard(
                              onCheckbox: (a) {
                                setState(() {
                                  switch (widget.orderType) {
                                    case OrderTypes.myOrder:
                                      LoadingScreenServices.myOrdersList
                                          .firstWhere((order) => order.id == widget.order.id)
                                          .products
                                          .removeWhere((product) => product.id == productDetail.id);
                                      break;
                                    case OrderTypes.allOrder:
                                      LoadingScreenServices.allOrdersList
                                          .firstWhere((order) => order.id == widget.order.id)
                                          .products
                                          .removeWhere((product) => product.id == productDetail.id);
                                      break;
                                    case OrderTypes.orders:
                                      LoadingScreenServices.notAssignedOrdersList
                                          .firstWhere((order) => order.id == widget.order.id)
                                          .products
                                          .removeWhere((product) => product.id == productDetail.id);
                                      break;
                                  }
                                  productsAry.removeAt(index);
                                });
                              },
                              productData: productDetail,
                              index: index,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (Services.isSupplierManager())
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'الزوائد',
                                style: darkBold,
                              ),
                              Text(
                                "${StringUtils().oCcy.format(widget.remaining)}" +
                                    " ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'إجمالي الحسم',
                                style: darkBold,
                              ),
                              Text(
                                "${StringUtils().oCcy.format(widget.totalDiscount)}" +
                                    " ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          "${StringUtils().oCcy.format(widget.subTotal)}" +
                              " ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          StringUtils.total,
                          style: informationStyle,
                        ),
                        Text(
                          "${StringUtils().oCcy.format(int.parse(widget.total.split('.')[0]))}" +
                              " ${LoadingScreenServices.companyInformation.currency}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                  !Services.isSupplierManager()
                      ? Column(
                          children: [
                            SizedBox(height: 5),
                            int.parse(widget.order.orderStatusId) <= 4 && int.parse(widget.order.underUpdate) != 1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        KammunButton(
                                          text: widget.order.orderStatusId == "1"
                                              ? "قبول الطلب"
                                              : widget.order.orderStatusId == "2"
                                                  ? "الطلب جاهز"
                                                  : widget.order.orderStatusId == "3"
                                                      ? "مع التوصيل"
                                                      : "تم التوصيل",
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          color: widget.order.orderStatusId == "1"
                                              ? Colors.green[700]
                                              : widget.order.orderStatusId == "2"
                                                  ? Colors.yellow[700]
                                                  : Colors.cyan[700],
                                          onTap: () async {
                                            int changeStatus = 0;
                                            setState(() {
                                              isLoading = true;
                                              errorAlert = false;
                                            });
                                            if (widget.order.orderStatusId == "1")
                                              changeStatus = 2;
                                            else if (widget.order.orderStatusId == "2")
                                              changeStatus = 3;
                                            else if (widget.order.orderStatusId == "3")
                                              changeStatus = 4;
                                            else if (widget.order.orderStatusId == "4") changeStatus = 5;

                                            bool x = await OrderServices.changeOrderStatus(
                                                widget.order.id.toString(), changeStatus);

                                            if (x) {
                                              setState(() {
                                                widget.order.orderStatusId = changeStatus.toString();
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
                                                    errorAlert = false;
                                                  });
                                                  changeStatus = 7;

                                                  bool x = await OrderServices.changeOrderStatus(
                                                      widget.order.id.toString(), changeStatus);

                                                  if (x) {
                                                    setState(() {
                                                      widget.order.orderStatusId = changeStatus.toString();
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
                                          text: "إلغاء الطلب",
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
                                                    errorAlert = false;
                                                  });
                                                  changeStatus = 6;

                                                  bool x = await OrderServices.changeOrderStatus(
                                                      widget.order.id.toString(), changeStatus);

                                                  if (x) {
                                                    setState(() {
                                                      widget.order.orderStatusId = changeStatus.toString();
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
                                  )
                                : ['6', '7'].contains(widget.order.orderStatusId)
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          LabelRow(
                                              rightSideText: 'تم إلغاء الطلب من قبل ابو الزين',
                                              leftSideText: '',
                                              leftSideStyle: mainStyle),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: KammunButton(
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
                                                        errorAlert = false;
                                                      });
                                                      changeStatus = 1;

                                                      bool result = await OrderServices.changeOrderStatus(
                                                          widget.order.id.toString(), changeStatus);
                                                      Services.resultFlushBar(context: context, result: result);

                                                      if (result) {
                                                        setState(() {
                                                          widget.order.orderStatusId = changeStatus.toString();
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
                                                    title: "استعادة الطلب",
                                                    text: "هل أنت متأكد انك تريد استعادة الطلب ؟",
                                                    dialogButtons: decisionButton,
                                                    context: context);
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                          ],
                        )
                      : SizedBox(
                          height: 10,
                        ),
                ],
              ),
      ),
    );
  }

  bool newSubWarehouse(int index) {
    if (index == 0) return true;
    return productsAry[index].subWarehouseId != productsAry[index - 1].subWarehouseId;
  }

  @override
  bool get wantKeepAlive => true;
}

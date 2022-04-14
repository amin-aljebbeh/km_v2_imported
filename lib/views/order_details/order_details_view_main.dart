import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/service.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

// ignore: must_be_immutable
class OrderDetailViewMain extends StatefulWidget {
  int subTotal;
  double remaining;
  double totalDiscount;
  OrdersOriginalData order;
  final OrderTypes orderType;

  OrderDetailViewMain({
    Key key,
    this.subTotal,
    this.order,
    @required this.orderType,
    this.remaining,
    this.totalDiscount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewMainState();
  }
}

class OrderDetailViewMainState extends State<OrderDetailViewMain>
    with AutomaticKeepAliveClientMixin<OrderDetailViewMain> {
  static List<OrderProducts> productsAry;
  getArray() {
    productsAry = [];
    productsAry.addAll(widget.order.products);
    productsAry.removeWhere((product) => product.pivot.deletedAt != 'null');

    if (LoadingScreenServices.subWarehouses.length == 1) {
      productsAry.sort((a, b) {
        if (a.pivot.subWarehouseId > b.pivot.subWarehouseId) {
          return -1;
        } else if (a.pivot.subWarehouseId < b.pivot.subWarehouseId) {
          return 1;
        } else {
          return 0;
        }
      });
    } else {
      productsAry.sort((a, b) {
        if (a.pivot.subWarehouseId > b.pivot.subWarehouseId) {
          return 1;
        } else if (a.pivot.subWarehouseId < b.pivot.subWarehouseId) {
          return -1;
        } else {
          return 0;
        }
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
        padding: const EdgeInsets.only(left: 0, top: 0, right: 20, bottom: 010),
        child: isLoading
            ? const Center(child: Loader())
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
                      padding: const EdgeInsets.only(left: 20.0, top: 0.0),
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productsAry == null ? 1 : productsAry.length,
                      itemBuilder: (BuildContext context, int index) {
                        OrderProducts productDetail = productsAry[index];
                        return Column(
                          children: [
                            if (newSubWarehouse(index))
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: ColorUtils.searchGreyColor,
                                child: Center(
                                  child: Text(
                                    LoadingScreenServices.subWarehouses
                                        .firstWhere(
                                          (subWarehouse) => subWarehouse.id == productDetail.pivot.subWarehouseId,
                                          orElse: () => SubWarehouse(name: 'No element'),
                                        )
                                        .name,
                                    style: labelStyle,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 20,
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
                                    case OrderTypes.none:
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
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'الزوائد',
                                style: darkBold,
                              ),
                              Text(
                                "${StringUtils().oCcy.format(widget.remaining)}"
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
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'إجمالي الحسم',
                                style: darkBold,
                              ),
                              Text(
                                "${StringUtils().oCcy.format(widget.totalDiscount)}"
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
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                StringUtils.subtotal,
                                style: darkBold,
                              ),
                              Text(
                                "${StringUtils().oCcy.format(widget.subTotal)}"
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
                ],
              ),
      ),
    );
  }

  bool newSubWarehouse(int index) {
    if (index == 0) return true;
    return productsAry[index].pivot.subWarehouseId != productsAry[index - 1].pivot.subWarehouseId;
  }

  @override
  bool get wantKeepAlive => true;
}

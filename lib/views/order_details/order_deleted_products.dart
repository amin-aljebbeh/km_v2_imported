import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class OrderDeletedProducts extends StatefulWidget {
  int subTotal;
  String total;
  OrdersOriginalData order;
  final OrderTypes orderType;

  OrderDeletedProducts({
    this.subTotal,
    this.total,
    this.order,
    @required this.orderType,
  });

  @override
  State<StatefulWidget> createState() {
    return OrderDeletedProductsState();
  }
}

class OrderDeletedProductsState extends State<OrderDeletedProducts>
    with AutomaticKeepAliveClientMixin<OrderDeletedProducts> {
  static List<OrderProducts> productsAry;
  getArray() {
    productsAry = List<OrderProducts>();
    productsAry.addAll(widget.order.products);
    productsAry.removeWhere((product) => product.pivot.deletedAt == 'null');

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
        padding: EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
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
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                color: ColorUtils.searchGreyColor,
                                child: Center(
                                  child: Text(
                                    LoadingScreenServices.subWarehouses
                                        .firstWhere(
                                          (subWarehouse) => subWarehouse.id == productDetail.subWarehouseId,
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
                              onCheckbox: (a) {},
                              productData: productDetail,
                              index: index,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
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

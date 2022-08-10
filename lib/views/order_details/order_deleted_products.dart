import 'package:kammun_app/views/loading/loading_services.dart';

import '../../core/core_importer.dart';

// ignore: must_be_immutable
class OrderDeletedProducts extends StatefulWidget {
  String total;
  OrdersOriginalData order;
  final OrderTypes orderType;

  OrderDeletedProducts({Key key, this.total, this.order, @required this.orderType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDeletedProductsState();
  }
}

class OrderDeletedProductsState extends State<OrderDeletedProducts>
    with AutomaticKeepAliveClientMixin<OrderDeletedProducts> {
  static List<OrderProducts> productsAry;
  getArray() {
    productsAry = [];
    productsAry.addAll(widget.order.products);
    productsAry.removeWhere((product) => product.pivot.deletedAt == 'null');

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
        padding: const EdgeInsets.only(left: 0, top: 10, right: 20, bottom: 10),
        child: isLoading
            ? const Center(child: Loader())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  errorAlert
                      ? AlertMessages(
                          text: 'خطأ اثناء محاولة تغيير حالة الطلب',
                          messageType: 'internetError',
                          headerText: 'حدث خطأ')
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
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
                                            orElse: () => SubWarehouse(name: 'No element'))
                                        .name,
                                    style: labelStyle,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                              ),
                            OrderDetailViewMainCard(onCheckbox: (a) {}, productData: productDetail, index: index),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
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

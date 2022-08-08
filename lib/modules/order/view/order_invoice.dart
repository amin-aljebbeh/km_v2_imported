import 'package:flutter/material.dart';
import 'package:kammun_app/modules/order/services/order_services.dart';
import '../../../core/core_importer.dart';
import '../models/get_order_model.dart';

class OrderInvoice extends StatelessWidget {
  final GetOrderResponse orderData;
  const OrderInvoice({Key key, this.orderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<KeyValueModel> children = [];
        children.addAll(orderData.showData.invoiceInfo);
        children.removeLast();
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: const NormalAppBar(pop: true, title: 'تفاصيل الطلب'),
          body: SafeArea(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 25, right: 16),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('المنتجات المطلوبة' '   ', style: informationStyle),
                                  Text(
                                      '( ${orderData.order.products.where((product) => product.pivot.deletedAt == 'null').toList().length} منتج )',
                                      style: disableStyle),
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        navigatorKey.currentContext,
                                        MaterialPageRoute(
                                            builder: (context) => OrderDetailsTabView(orderData: orderData)));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('عرض الكل',
                                          style: flushBarStyle.copyWith(
                                              color: ColorUtils.kmColors,
                                              decoration: TextDecoration.underline,
                                              decorationThickness: 20))))
                            ]))),
                HorizontalProducts(
                    products: OrderServices.convertOrderProductToProductData(
                        orderProducts:
                            orderData.order.products.where((product) => product.pivot.deletedAt == 'null').toList())),
                InvoiceCard(
                    info: state.supportedCityState.supportedCities
                        .firstWhere((city) => city.id.toString() == orderData.order.address.supportedCityId)
                        .name,
                    title: StringUtils.address,
                    icon: Icons.location_on,
                    viewButton: false,
                    details: orderData.order.address.street,
                    onChange: () {},
                    forAddress: true),
                InvoiceCard(
                    icon: Icons.payment,
                    title: 'طريقة الدفع',
                    viewButton: false,
                    info: state.paymentState.paymentMethods
                        .firstWhere((method) => method.id == orderData.order.paymentMethodId)
                        .name,
                    onChange: () {}),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (orderData.order.userNotes != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الملاحظات', style: informationStyle.copyWith(fontSize: 20)),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorUtils.searchGreyColor, width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(orderData.order.userNotes ?? ' ', style: textFieldStyle)),
                            ),
                          ],
                        ),
                      InvoiceInfoWidget(title: 'تفاصيل الفاتورة', children: children),
                      KCard(
                          radius: 6,
                          child: InvoiceRow(
                              style: informationStyle.copyWith(color: ColorUtils.kmColors),
                              children: orderData.showData.invoiceInfo.last.info,
                              title: orderData.showData.invoiceInfo.last.key,
                              info: StringUtils()
                                  .oCcy
                                  .format(int.parse(orderData.showData.invoiceInfo.last.value.split('.')[0])))),
                      orderData.showData.paymentInfo != null
                          ? InvoiceInfoWidget(title: 'تفاصيل الدفع', children: orderData.showData.paymentInfo)
                          : const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

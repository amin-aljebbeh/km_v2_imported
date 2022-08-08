import 'package:flutter/material.dart';
import 'package:kammun_app/modules/order/redux/order_action.dart';
import '../../../core/core_importer.dart';
import '../../cart/redux/cart_action.dart';

class OrderProblemView extends StatelessWidget {
  static const String routeName = '/OrderProblemView';
  const OrderProblemView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          pop: false,
          child: Scaffold(
            appBar: const NormalAppBar(title: 'تغييرات طرأت أثناء التسوق', pop: false),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    children: [
                      if (state.orderState.notActiveProducts.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('منتجات نفذت أثناء التسوق' '   ', style: informationStyle),
                                  Text('( ${state.orderState.notActiveProducts.length} منتج )', style: disableStyle)
                                ],
                              ),
                            ),
                            HorizontalProducts(products: state.orderState.notActiveProducts),
                          ],
                        ),
                      if (state.orderState.priceProducts.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('منتجات تغير سعرها أثناء التسوق   ', style: informationStyle),
                                  Text('( ${state.orderState.priceProducts.length} منتج )', style: disableStyle)
                                ],
                              ),
                            ),
                            ListView.builder(
                              primary: false,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.orderState.priceProducts.length,
                              itemBuilder: (BuildContext context, int index) => OrderProblemProduct(
                                hero: index,
                                product: state.orderState.priceProducts[index],
                                lastProduct: index == state.orderState.priceProducts.length - 1,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                KCard(
                  color: ColorUtils.silverColor,
                  radius: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40, right: 25, left: 25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KButton(
                            color: ColorUtils.kmColors,
                            onTap: () {
                              StoreProvider.of<AppState>(context).dispatch(NoError());
                              StoreProvider.of<AppState>(context).dispatch(StartLoading());
                              StoreProvider.of<AppState>(context).dispatch(UpdateOrderPrices());
                            },
                            text: 'تحديث الطلب',
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                          ),
                          KButton(
                            color: ColorUtils.primaryColor,
                            onTap: () {
                              StoreProvider.of<AppState>(context).dispatch(NoError());
                              List<ProductData> products = [];
                              products.addAll(StoreProvider.of<AppState>(context).state.orderState.notActiveProducts);
                              for (int i = 0; i < products.length; i++) {
                                var product = products[i];
                                StoreProvider.of<AppState>(context).dispatch(RemoveProduct(productId: product.id));
                              }
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetOrderProblemProducts(notActiveProducts: [], priceProducts: []));

                              RestartWidget.restartApp(context);
                            },
                            text: 'محاولة إيجاد بدائل',
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
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

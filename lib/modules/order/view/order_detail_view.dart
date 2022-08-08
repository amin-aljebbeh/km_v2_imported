import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';

class OrderDetailView extends StatefulWidget {
  final List<OrderProducts> products;

  const OrderDetailView({Key key, this.products}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewState();
  }
}

class OrderDetailViewState extends State<OrderDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.only(top: 20.0),
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.products == null ? 0 : widget.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        OrderProducts orderDetail = widget.products[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {},
                          child: OrderDetailViewCard(
                            img: orderDetail.images.isNotEmpty ? orderDetail.images[0].imageFileName : '',
                            productName: orderDetail.name,
                            quantity: orderDetail.quantity,
                            price: int.parse(orderDetail.pivot.purchasePrice),
                            unit: orderDetail.unit ?? '',
                            productCount: orderDetail.pivot.quantity.toString(),
                            productId: orderDetail.id,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

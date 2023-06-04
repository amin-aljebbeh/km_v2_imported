import '../../../../core/core_importer.dart';
import '../../../orders_feature/domain/entities/order_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../order_details_services.dart';
import '../widgets/supplier_order_details_widget.dart';

class OrderProductsPage extends StatefulWidget {
  final OrderEntity order;
  final OrderTypes orderType;
  final bool deleted;

  const OrderProductsPage({Key key, this.order, @required this.orderType, this.deleted}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrderProductsPageState();
}

class OrderProductsPageState extends State<OrderProductsPage> with AutomaticKeepAliveClientMixin<OrderProductsPage> {
  List<ProductEntity> productsAry;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    productsAry = orderProducts(deleted: widget.deleted, products: widget.order.products);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20.0, top: 0.0, right: 20, bottom: 10),
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productsAry == null ? 1 : productsAry.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderProductWidget(
                      onCheckbox: () {
                        if (!widget.deleted) {
                          setState(() {
                            switch (widget.orderType) {
                              case OrderTypes.myOrder:
                                StaticVariables.myOrdersList
                                    .firstWhere((order) => order.id == widget.order.id)
                                    .products
                                    .removeWhere((product) => product.id == productsAry[index].id);
                                break;
                              case OrderTypes.allOrder:
                                StaticVariables.allOrdersList
                                    .firstWhere((order) => order.id == widget.order.id)
                                    .products
                                    .removeWhere((product) => product.id == productsAry[index].id);
                                break;
                              case OrderTypes.search:
                                StaticVariables.phoneOrderList
                                    .firstWhere((order) => order.id == widget.order.id)
                                    .products
                                    .removeWhere((product) => product.id == productsAry[index].id);
                                break;
                              case OrderTypes.none:
                                break;
                            }
                            // switch (state.searchOrdersState.searchOrdersType) {
                            //   case SearchOrdersTypes.phoneNumber:
                            //   case SearchOrdersTypes.id:
                            //     state.searchOrdersState.orders
                            //         .firstWhere((order) => order.id == widget.order.id)
                            //         .products
                            //         .removeWhere((product) => product.id == productsAry[index].id);
                            //     break;
                            //   case SearchOrdersTypes.none:
                            //     state.ordersState.orders
                            //         .firstWhere((order) => order.id == widget.order.id)
                            //         .products
                            //         .removeWhere((product) => product.id == productsAry[index].id);
                            //     break;
                            // }
                            productsAry.removeAt(index);
                          });
                        }
                      },
                      productData: productsAry[index],
                      newSubWarehouse: newSubWarehouse(index),
                    );
                  },
                ),
              ),
              if (Services.hasRole(context, supplierRole)) SupplierOrderDetailsWidget(order: widget.order),
            ],
          ),
        );
      },
    );
  }

  bool newSubWarehouse(int index) {
    if (index == 0) return true;
    return productsAry[index].pivot.subWarehouseId != productsAry[index - 1].pivot.subWarehouseId;
  }

  @override
  bool get wantKeepAlive => true;
}

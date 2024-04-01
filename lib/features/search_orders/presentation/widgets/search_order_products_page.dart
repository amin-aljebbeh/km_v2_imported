import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_action.dart';

import '../../../../core/core_importer.dart';
import '../../../order_details/order_details_services.dart';
import '../../../order_details/presentation/widgets/supplier_order_details_widget.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/redux/orders_action.dart';
import '../../../products/domain/entities/product_entity.dart';

class SearchOrderProductsPage extends StatefulWidget {
  final OrderEntity order;
  final bool deleted;
  final Map<int, bool> authorizedWarehouses;
  const SearchOrderProductsPage({Key key, this.order, this.deleted, this.authorizedWarehouses = const {}})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OrderProductsPageState();
}

class OrderProductsPageState extends State<SearchOrderProductsPage>
    with AutomaticKeepAliveClientMixin<SearchOrderProductsPage> {
  List<ProductEntity> productsAry;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        productsAry = orderProducts(
            deleted: widget.deleted,
            products: state.searchOrdersState.orders.firstWhere((element) => element.id == widget.order.id).products,
            context: context);
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
                          setState(() {});
                          switch (state.searchOrdersState.searchOrdersType) {
                            case SearchOrdersTypes.phoneNumber:
                            case SearchOrdersTypes.id:
                              state.searchOrdersState.orders
                                  .firstWhere((order) => order.id == widget.order.id)
                                  .products
                                  .removeWhere((product) => product.id == productsAry[index].id);
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetSearchOrders(orders: state.searchOrdersState.orders));
                              break;
                            case SearchOrdersTypes.none:
                              state.ordersState.orders
                                  .firstWhere((order) => order.id == widget.order.id)
                                  .products
                                  .removeWhere((product) => product.id == productsAry[index].id);
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetViewOrders(orders: state.ordersState.orders));
                              break;
                          }
                        }
                      },
                      productData: productsAry[index],
                      // newSubWarehouse: newSubWarehouse(index),
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

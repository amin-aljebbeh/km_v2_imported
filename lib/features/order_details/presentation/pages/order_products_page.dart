import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../order_details_services.dart';
import '../widgets/order_sub_warehouse_products_widget.dart';
import '../widgets/supplier_order_details_widget.dart';

class OrderProductsPage extends StatefulWidget {
  final OrderEntity order;
  final bool deleted;
  const OrderProductsPage({Key key, this.order, this.deleted}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrderProductsPageState();
}

class OrderProductsPageState extends State<OrderProductsPage> with AutomaticKeepAliveClientMixin<OrderProductsPage> {
  Map<int, List<ProductEntity>> subWarehousesProducts;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        subWarehousesProducts = getSubWarehousesProducts(
            deleted: widget.deleted,
            subWarehouses: widget.order.subWarehouseAuthCodes.map((code) => code.subWarehouseId).toList(),
            products: state.ordersState.orders.firstWhere((element) => element.id == widget.order.id).products,
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
                  itemCount: subWarehousesProducts == null ? 1 : subWarehousesProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderSubWarehouseProductsWidget(productsAry: subWarehousesProducts.values.elementAt(index));
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

  @override
  bool get wantKeepAlive => true;
}

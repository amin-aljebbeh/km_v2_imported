import '../../../../core/core_importer.dart';
import '../../../order_details/order_details_services.dart';
import '../../../order_details/presentation/widgets/order_sub_warehouse_products_widget.dart';
import '../../../order_details/presentation/widgets/supplier_order_details_widget.dart';
import '../../../orders/domain/entities/order_entity.dart';
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
  Map<int, List<ProductEntity>> subWarehousesProducts;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        subWarehousesProducts = getSubWarehousesProducts(
            deleted: widget.deleted, products: state.searchOrdersState.orders[0].products, context: context);
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

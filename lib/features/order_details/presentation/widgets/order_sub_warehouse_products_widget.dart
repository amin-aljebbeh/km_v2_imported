import '../../../../core/core_importer.dart';
import '../../../general_information/data/models/sub_warehouse_model.dart';
import '../../../general_information/domain/entities/sub_warehouse_entity.dart';
import '../../../orders/presentation/redux/orders_action.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../search_orders/presentation/redux/search_orders_action.dart';
import 'pinput_sms.dart';

class OrderSubWarehouseProductsWidget extends StatefulWidget {
  final List<ProductEntity> productsAry;
  const OrderSubWarehouseProductsWidget({Key key, this.productsAry}) : super(key: key);

  @override
  State<OrderSubWarehouseProductsWidget> createState() => _OrderSubWarehouseProductsWidgetState();
}

class _OrderSubWarehouseProductsWidgetState extends State<OrderSubWarehouseProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        if (widget.productsAry.isEmpty) return const SizedBox();
        SubWarehouseEntity subWarehouse = state.shoppersState.shopper.level.subWarehouses.firstWhere(
            (subWarehouse) => subWarehouse.id == widget.productsAry[0].pivot.subWarehouseId,
            orElse: () => SubWarehouseModel(name: 'No element', requireAuthCodes: 0));
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              color: searchGreyColor,
              child: Center(child: Text(subWarehouse.name, style: labelStyle)),
              width: MediaQuery.of(context).size.width,
              height: 20,
            ),
            (subWarehouse.requireAuthCodes == 1 &&
                    Services.hasRole(context, shopperRole) &&
                    !state.orderDetailsState.authenticatedSubWarehouses[int.parse(widget.productsAry[0].pivot.orderId)]
                        .contains(subWarehouse.id))
                ? FilledRoundedPinPut(
                    subWareHouseId: subWarehouse.id, orderId: int.parse(widget.productsAry[0].pivot.orderId))
                : Column(
                    children: widget.productsAry
                        .map((product) => OrderProductWidget(
                              productData: product,
                              onCheckbox: () {
                                widget.productsAry.remove(product);
                                if (product.pivot.deletedAt == 'null') {
                                  setState(() {});
                                  switch (state.searchOrdersState.searchOrdersType) {
                                    case SearchOrdersTypes.phoneNumber:
                                    case SearchOrdersTypes.id:
                                      state.searchOrdersState.orders
                                          .firstWhere((order) => order.id.toString() == product.pivot.orderId)
                                          .products
                                          .removeWhere((product2) => product.id == product2.id);
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(SetSearchOrders(orders: state.searchOrdersState.orders));
                                      break;
                                    case SearchOrdersTypes.none:
                                      state.ordersState.orders
                                          .firstWhere((order) => order.id.toString() == product.pivot.orderId)
                                          .products
                                          .removeWhere((product2) => product.id == product2.id);
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(SetViewOrders(orders: state.ordersState.orders));
                                      break;
                                  }
                                }
                              },
                            ))
                        .toList(),
                  )
          ],
        );
      },
    );
  }
}

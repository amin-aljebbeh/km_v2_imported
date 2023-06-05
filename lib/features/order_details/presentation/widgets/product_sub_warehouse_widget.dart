import 'package:kammun_app/features/order_details/presentation/redux/order_details_action.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../order_details_services.dart';

class ProductSubWarehouse extends StatefulWidget {
  final ProductEntity product;

  const ProductSubWarehouse({Key key, this.product}) : super(key: key);

  @override
  _ProductSubWarehouseState createState() => _ProductSubWarehouseState();
}

class _ProductSubWarehouseState extends State<ProductSubWarehouse> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: subWarehousesItems(context: context, subWarehouseId: widget.product.subWarehouseId),
      onChanged: (a) {
        StoreProvider.of<AppState>(context).dispatch(UpdateOrderProductAction(
            productId: int.parse(widget.product.pivot.productId),
            updateValue: a.toString(),
            updateKey: 'sub_warehouse_id',
            orderId: int.parse(widget.product.pivot.orderId),
            context: context));
        setState(() => widget.product.subWarehouseId = a);
      },
      hint: subWarehousesItems(context: context, subWarehouseId: widget.product.subWarehouseId)
          .firstWhere((subWarehouse) => subWarehouse.value == widget.product.subWarehouseId,
              orElse: () => subWarehousesItems(context: context, subWarehouseId: widget.product.subWarehouseId)
                  .firstWhere((subWarehouse) => subWarehouse.value == widget.product.pivot.subWarehouseId,
                      orElse: () => const DropdownMenuItem<int>(child: Text('No element'), value: 0)))
          .child,
    );
  }
}

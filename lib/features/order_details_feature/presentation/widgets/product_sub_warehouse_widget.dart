import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../order_details/services/order_details_services.dart';
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
        OrderDetailsServices.updateOrder(
            orderId: widget.product.pivot.orderId,
            context: context,
            updateKey: 'sub_warehouse_id',
            updateValue: a.toString(),
            productId: widget.product.pivot.productId);
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

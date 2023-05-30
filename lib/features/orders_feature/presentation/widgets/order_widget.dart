import 'package:intl/intl.dart';
import 'package:kammun_app/features/order_details/pages/order_details_tab_view.dart';
import 'package:kammun_app/features/orders_feature/domain/entities/order_entity.dart';
import 'package:kammun_app/features/orders_feature/presentation/widgets/admin_order_foot.dart';
import 'package:kammun_app/features/orders_feature/presentation/widgets/admin_order_head.dart';
import 'package:kammun_app/features/orders_feature/presentation/widgets/admin_order_info_widget.dart';
import 'package:kammun_app/features/orders_feature/presentation/widgets/supplier_order_foot.dart';
import 'package:kammun_app/features/orders_feature/services.dart';

import '../../../../core/core_importer.dart';
import 'supplier_order_head.dart';

class OrderWidget extends StatelessWidget {
  final OrderEntity order;
  final OrderTypes orderType;
  final bool pop;

  const OrderWidget({Key key, @required this.order, @required this.orderType, this.pop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsTabView(
                  //todo
                  // orderData: order,
                  deletedProducts: Services.hasRole(context, operationManagerRole) &&
                      order.products.where((product) => product.pivot.deletedAt != 'null').isNotEmpty,
                  subTotal: int.parse(order.total.toString().split('.')[0]) -
                      int.parse(order.supportedCityCost.toString().split('.')[0]) -
                      int.parse(order.deliveryCost.split('.')[0]),
                  orderType: orderType))),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: frameColor(order), width: 5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Services.hasRole(context, supplierRole) ? SupplierOrderHead(order: order) : AdminOrderHead(order: order),
              if (!Services.hasRole(context, supplierRole)) AdminOrderInfoWidget(order: order, pop: pop),
              LabelRow(
                  rightSideText: orderDate,
                  leftSideText: DateFormat('a h:mm - dd-MM-yyyy').format(order.createdAt),
                  leftSideStyle: disableStyle),
              Services.hasRole(context, supplierRole) ? SupplierOrderFoot(order: order) : AdminOrderFoot(order: order),
              if (Services.hasRole(context, supplierRole))
                if (order.userNotes.toString() != 'null')
                  KammunButton(
                    text: watchNote,
                    onTap: () {
                      showMyDialog(
                          context: context,
                          title: costumerNote,
                          text: order.userNotes,
                          dialogButtons: [const CloseWidget()]);
                    },
                    color: Colors.indigoAccent,
                  ),
              Padding(padding: const EdgeInsets.only(top: 8.0), child: Divider(thickness: 5, color: kmColors2))
            ],
          ),
        ),
      ),
    );
  }
}

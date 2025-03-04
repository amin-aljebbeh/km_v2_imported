import 'package:intl/intl.dart';
import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';
import 'package:kammun_app/features/orders/orders_services.dart';
import 'package:kammun_app/features/orders/presentation/widgets/admin_order_foot.dart';
import 'package:kammun_app/features/orders/presentation/widgets/admin_order_head.dart';
import 'package:kammun_app/features/orders/presentation/widgets/admin_order_info_widget.dart';
import 'package:kammun_app/features/orders/presentation/widgets/supplier_order_foot.dart';
import 'package:kammun_app/features/search_orders/presentation/widgets/search_order_tabs_page.dart';

import '../../../../core/core_importer.dart';
import '../../../orders/presentation/widgets/operations_buttons_widget.dart';
import '../../../orders/presentation/widgets/supplier_order_head.dart';

class SearchOrderWidget extends StatelessWidget {
  final OrderEntity order;

  const SearchOrderWidget({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchOrderTabsPage(
                  order: order,
                  deleted: Services.hasRole(context, operationManagerRole) &&
                      order.products.where((product) => product.pivot.deletedAt != 'null').isNotEmpty))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration:
                  BoxDecoration(border: Border.all(color: frameColor(order: order, context: context), width: 5)),
              padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Services.hasRole(context, supplierRole)
                      ? SupplierOrderHead(order: order)
                      : AdminOrderHead(order: order),
                  if (!Services.hasRole(context, supplierRole)) AdminOrderInfoWidget(order: order),
                  LabelRow(
                      rightSideText: orderDate,
                      leftSideText: DateFormat('a h:mm - dd-MM-yyyy').format(order.createdAt),
                      leftSideStyle: disableStyle),
                  Services.hasRole(context, supplierRole)
                      ? SupplierOrderFoot(order: order)
                      : AdminOrderFoot(order: order),
                  if (Services.hasRole(context, supplierRole) &&
                      Services.hasPermission(context, showOrderAddressPermission))
                    LabelRow(
                        rightSideText: address + ' : ',
                        leftSideText: order.address.street +
                            ' ' +
                            order.address.building +
                            ' طابق ' +
                            order.address.floor +
                            ' ' +
                            order.address.description,
                        leftSideStyle: informationStyle),
                ],
              )),
          if (Services.hasRole(context, operationManagerRole) || Services.hasRole(context, shopperRole))
            OperationButtonsWidget(order: order),
          if (Services.hasRole(context, supplierRole))
            if (order.userNotes.toString() != 'null' && order.userNotes.isNotEmpty)
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
    );
  }
}

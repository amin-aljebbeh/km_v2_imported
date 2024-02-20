import '../../../../core/core_importer.dart';
import '../../../shoppers/domain/entities/shopper_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../redux/orders_action.dart';

class AssignmentManagementWidget extends StatelessWidget {
  const AssignmentManagementWidget({Key key, this.order}) : super(key: key);
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    String shopper;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (order.shopper != null)
          if (int.parse(order.orderStatusId) < 5)
            if(Services.hasPermission(context, assignOrderPermission))
            Padding(
                padding: const EdgeInsets.all(8),
                child: KammunButton(
                    color: kmColors,
                    width: MediaQuery.of(context).size.width / 4,
                    text: 'تحويل',
                    onTap: () {
                      showMyDialog(
                          context: context,
                          title: 'تحويل',
                          text: 'هل أنت متأكد من رغبتك في تحويل الطلب لكابتن جديد ؟',
                          dialogButtons: [
                            KammunButton(
                                color: kmColors,
                                onTap: () {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(ReAssignOrderAction(orderId: order.id, context: context));
                                  Navigator.pop(context);
                                },
                                width: 100,
                                text: yes),
                            KammunButton(color: kmColors, onTap: () => Navigator.pop(context), width: 100, text: no),
                          ]);
                    })),
        if (Services.hasRole(context, agentRole))
          if (order.shopper != null)
            if (order.shopper.admin != null)
              if (order.shopper.admin.phone != null)
                Wrap(
                  children: [
                    InkWell(
                      child: Icon(Icons.contact_phone_rounded, color: kmColors),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: order.shopper.admin.phone));
                        Toast.show('تم نسخ رقم الكابتن', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        child: Icon(Icons.phone_rounded, color: kmColors),
                        onTap: () => Services.makePhoneCall(order.shopper.admin.phone),
                      ),
                    ),
                  ],
                ),
        if( Services.hasPermission(context, assignOrderPermission))

          Expanded(
          child: KSearchableDropdown(
            hint: order.shopper != null ? order.shopper.name : chooseShopper,
            search: shopper,
            items: Services.shoppersNameList(context),
            onChanged: (value) async {
              if (value != null) {
                String shopperId = Services.selectedShopperId(value, context);
                int shopperLevelId = Services.selectedShopperLevelId(value, context);
                shopper = value;
                order.shopper = ShopperEntity(
                    name: value.replaceAll(' ✅', '').replaceAll(' ❌', ''),
                    id: int.parse(shopperId),
                    levelId: shopperLevelId);
                StoreProvider.of<AppState>(context).dispatch(
                    AssignOrderToShopperAction(orderId: order.id, assignedId: int.parse(shopperId), context: context));
              }
            },
          ),
        ),
      ],
    );
  }
}

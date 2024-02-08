import 'package:kammun_app/features/orders/data/models/order_model.dart';
import 'package:kammun_app/features/orders/domain/entities/order_entity.dart';

import '../../../../core/core_importer.dart';
import '../../orders_services.dart';
import '../redux/orders_action.dart';

class OperationButtonsWidget extends StatelessWidget {
  final OrderEntity order;

  const OperationButtonsWidget({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        OrderEntity otherOrder = state.searchOrdersState.searchOrdersType == SearchOrdersTypes.none
            ? state.ordersState.orders.firstWhere(
                (otherOrder) => order.id != otherOrder.id && order.userId == otherOrder.userId,
                orElse: () => OrderModel(orderStatusId: '5'))
            : state.searchOrdersState.orders.firstWhere(
                (otherOrder) => order.id != otherOrder.id && order.userId == otherOrder.userId,
                orElse: () => OrderModel(orderStatusId: '5'));
        bool cancelOrderCondition =
            (int.parse(otherOrder.orderStatusId) <= 4) || Services.hasRole(context, operationManagerRole);
        return (state.loadingState.loading.isNotEmpty)
            ? const Loader()
            : Column(
                children: [
                  if (int.parse(order.orderStatusId) <= 4 && int.parse(order.underUpdate) != 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: KammunButton(
                              text: changeStatusButtonText(order.orderStatusId),
                              color: changeStatusButtonColor(order.orderStatusId),
                              onTap: () => store.dispatch(ChangeOrderStatusAction(
                                  statusId: newStatus(order.orderStatusId), orderId: order.id, context: context)),
                            ),
                          ),
                        ),
                        if (cancelOrderCondition)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: KammunButton(
                                onLongPress: () {
                                  if (Services.hasRole(context, operationManagerRole)) {
                                    List<DialogButton> decisionButton = [
                                      DialogButton(
                                        text: 'نعم',
                                        onTap: () => store.dispatch(
                                            ChangeOrderStatusAction(orderId: order.id, statusId: 7, context: context)),
                                      ),
                                      DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                                    ];
                                    showMyDialog(
                                        context: context,
                                        title: 'رفض الطلب',
                                        text: 'هل أنت متأكد انك تريد رفض الطلب ؟',
                                        dialogButtons: decisionButton);
                                  }
                                },
                                text: cancelOrder,
                                width: MediaQuery.of(context).size.width * 0.4,
                                color: Colors.red,
                                onTap: () {
                                  List<DialogButton> decisionButton = [
                                    DialogButton(
                                      text: 'نعم',
                                      onTap: () => store.dispatch(
                                          ChangeOrderStatusAction(orderId: order.id, statusId: 6, context: context)),
                                    ),
                                    DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                                  ];
                                  showMyDialog(
                                      context: context,
                                      title: 'إلغاء الطلب',
                                      text: 'هل أنت متأكد انك تريد إلغاء الطلب ؟',
                                      dialogButtons: decisionButton);
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (['6', '7'].contains(order.orderStatusId) && Services.hasRole(context, operationManagerRole))
                    KammunButton(
                      text: 'استعادة الطلب',
                      width: MediaQuery.of(context).size.width,
                      color: kmColors,
                      onTap: () {
                        List<DialogButton> decisionButton = [
                          DialogButton(
                            text: 'نعم',
                            onTap: () {
                              Navigator.of(context).pop();
                              store.dispatch(ChangeOrderStatusAction(orderId: order.id, statusId: 1, context: context));
                            },
                          ),
                          DialogButton(text: 'لا', onTap: () => Navigator.of(context).pop()),
                        ];
                        showMyDialog(
                            context: context,
                            title: 'استعادة الطلب',
                            text: 'هل أنت متأكد انك تريد استعادة الطلب ؟',
                            dialogButtons: decisionButton);
                      },
                    ),
                  if ((!['5', '6', '7'].contains(order.orderStatusId)) ||
                      Services.hasRole(context, operationManagerRole))
                    KammunButton(
                      text: editOrder,
                      onTap: () {
                        lockOrderService(
                            orderId: order.id,
                            context: context,
                            userNote: order.userNotes,
                            supportedCityCost: order.supportedCityCost,
                            deliveryMethodCost: order.deliveryCost);
                        store.dispatch(LockOrderAction(orderId: order.id, context: context));
                      },
                      color: Colors.green,
                    ),
                  if (order.userNotes.toString() != 'null')
                    KammunButton(
                      text: watchNote,
                      onTap: () => showMyDialog(
                          context: context,
                          title: costumerNote,
                          text: order.userNotes,
                          dialogButtons: [const CloseWidget()]),
                      color: Colors.indigoAccent,
                    ),
                  if (order.underUpdate.toString() != '0')
                    KammunButton(
                      text: unLock,
                      onTap: () {
                        List<Widget> decisionButtons = [
                          DialogButton(
                            text: 'نعم',
                            onTap: () {
                              Navigator.of(context).pop();
                              store.dispatch(UnLockOrderAction(orderId: order.id, context: context));
                            },
                          ),
                          const CloseWidget()
                        ];
                        showMyDialog(
                            context: context, title: unLock, text: unLockConfirm, dialogButtons: decisionButtons);
                      },
                      color: Colors.blue[800],
                    ),
                ],
              );
      },
    );
  }
}

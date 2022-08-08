import 'package:flutter/material.dart';
import '../../order/redux/order_action.dart';
import '../../../core/core_importer.dart';
import '../../orders/redux/orders_action.dart';
import '../../orders/view/rating_view.dart';

class OrdersViewCard extends StatefulWidget {
  final OrdersOriginalData order;
  final int index;
  final int orderStatus;
  final String orderCreatedDate;
  final int underUpdate;
  final bool lastOrder;

  const OrdersViewCard({
    Key key,
    this.orderStatus,
    this.orderCreatedDate,
    this.underUpdate,
    this.order,
    this.index,
    this.lastOrder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrdersViewCardState();
}

class OrdersViewCardState extends State<OrdersViewCard> {
  String orderStatus = 'طلبك قيد المعالجة ⌛️';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.orderStatus) {
      case 1:
        orderStatus = 'طلبك قيد المعالجة ⌛️';
        break;
      case 2:
        orderStatus = 'تم قبول طلبك ✅';
        break;
      case 3:
        orderStatus = 'تم تجهيز الطلب 😎';
        break;
      case 4:
        orderStatus = 'تم إرسال طلبك مع كابتن التوصيل';
        break;
      case 5:
        orderStatus = 'تم توصيل طلبك بنجاح ';
        break;
      case 6:
        orderStatus = 'تم إلغاء الطلب من قبلكم 🚫';
        break;
      case 7:
        orderStatus = '😔 لم نستطع تأمين الطلب 😔';
        break;
      case 8:
        orderStatus = 'بانتظار إتمام عملية الدفع الإلكتروني';
        break;
      case 9:
        orderStatus = 'فشل في عملية الدفع الإلكتروني';
        break;
    }
    if (widget.underUpdate == 1) {
      orderStatus = 'طلبك معلق حتى تأكيد التعديل';
    }
    if (widget.underUpdate == 2) {
      orderStatus = 'يقوم مسؤول الطلب بتعديل طلبكم';
    }
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                StoreProvider.of<AppState>(context).dispatch(StartLoading());
                StoreProvider.of<AppState>(context).dispatch(GetOrder(orderId: widget.order.id, forCart: false));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    KCard(
                      radius: 6,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: LabelRow(
                                      rightSideText: 'الدفع النقدي : ',
                                      leftSideText: StringUtils()
                                              .oCcy
                                              .format(int.parse(widget.order.cashV.split('.')[0].replaceAll('-', '')))
                                              .toString() +
                                          ' ' +
                                          state.startupState.startModel.company.currency,
                                      leftSideStyle: int.parse(widget.order.cashV.split('.')[0]).isNegative
                                          ? informationStyle.copyWith(color: Colors.red)
                                          : informationStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: LabelRow(
                                      rightSideText: 'تاريخ الطلب : ',
                                      leftSideText: widget.orderCreatedDate,
                                      leftSideStyle: disableStyle,
                                    ),
                                  ),
                                  AutoSizeText(orderStatus, style: paragraphStyle, maxLines: 2)
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: ColorUtils.kmColors, width: 1),
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Icon(Icons.remove_red_eye, color: ColorUtils.kmColors, size: 30),
                                ),
                                const SizedBox(height: 10),
                                widget.order.orderStatusId == '1'
                                    ? GestureDetector(
                                        onTap: () async {
                                          showMyDialog(
                                            title: StringUtils.cancelOrder,
                                            text: 'هل أنت متأكد من رغبتك بإلغاء الطلب ؟',
                                            dialogButtons: [
                                              DialogButton(
                                                text: StringUtils.yes,
                                                onTap: () async {
                                                  StoreProvider.of<AppState>(context).dispatch(StartLoading());
                                                  StoreProvider.of<AppState>(context)
                                                      .dispatch(CancelOrder(orderId: widget.order.id.toString()));
                                                  StoreProvider.of<AppState>(context).dispatch(Pop());
                                                },
                                              ),
                                              const CloseWidget(),
                                            ],
                                          );
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.red[900],
                                              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                                        ),
                                      )
                                    : const SizedBox(height: 50, width: 50),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width,
                      child: (widget.order.orderStatusId == '5' && widget.order.userDeliveryRating == null)
                          ? KButton(
                              color: ColorUtils.kmColors,
                              onTap: () => settingModalBottomSheet(context, widget.index),
                              text: StringUtils.ratingOrder,
                            )
                          : ((widget.order.orderStatusId == '1') &&
                                  (widget.order.underUpdate == '0') &&
                                  (state.ordersState.updatedOrderId == -1))
                              ? KButton(
                                  color: ColorUtils.primaryColor,
                                  onTap: () {
                                    StoreProvider.of<AppState>(context).dispatch(StartLoading());
                                    StoreProvider.of<AppState>(context).dispatch(NoError());
                                    StoreProvider.of<AppState>(context).dispatch(LockOrder(orderId: widget.order.id));
                                  },
                                  text: StringUtils.editOrder,
                                )
                              : Container(),
                    ),
                    if (!widget.lastOrder) const Padding(padding: EdgeInsets.only(top: 8.0), child: KDivider())
                  ],
                ),
              ),
            ),
            if (widget.lastOrder) const EndOfPageWidget(),
          ],
        );
      },
    );
  }
}

import 'package:kammun_app/features/orders/presentation/widgets/orders_filter_widget.dart';

import '../../../../core/core_importer.dart';
import '../widgets/order_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            resizeToAvoidBottomInset: false,
            floatingActionButton: Services.hasRole(context, collectorRole) ||
                    Services.hasRole(context, mainCollectorRole) ||
                    Services.hasRole(context, agentRole)
                ? FloatingActionButton(
                    backgroundColor: kmColors,
                    onPressed: () {},
                    child: Text(StringUtils().oCcy.format(state.ordersState.totalOrdersNumber), style: userNameStyle))
                : const SizedBox(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (state.errorState.isError)
                      AlertMessages(
                          text: state.errorState.errorMessage, messageType: 'internetError', headerText: 'حدث خطأ'),
                    OrdersFilterWidget(),
                    state.loadingState.loading.isNotEmpty
                        ? const Center(child: Loader())
                        : state.ordersState.orders.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                                child: Center(
                                  child: Text('لا يوجد أي طلبات سابقة',
                                      style: mainStyle.copyWith(
                                          fontWeight: FontWeight.w700, color: primaryColor, fontSize: 20.0)),
                                ),
                              )
                            : const SizedBox(),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: state.ordersState.orders == null ? 0 : state.ordersState.orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (Services.hasRole(context, shopperRole) ||
                              state.ordersState.orders[index].shopper != null) {
                            state.ordersState.orders[index].orderArithmeticOperations(context);
                            if (!Services.hasRole(context, supplierRole)) {
                              state.ordersState.orders[index].orderProfits(context: context);
                            }
                          }
                          return OrderWidget(order: state.ordersState.orders[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:kammun_app/features/orders_feature/presentation/widgets/orders_filter_widget.dart';

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
                            : Container(padding: EdgeInsets.zero),
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
                            // todo orderArithmeticOperations
                          }
                          //todo divider
                          return OrderWidget(
                              pop: false, order: state.ordersState.orders[index], orderType: OrderTypes.allOrder);
                        },
                      ),
                    ),
                    if (state.ordersState.orders.isEmpty)
                      Container(
                        height: 50.0,
                        color: Colors.transparent,
                        child: Center(child: Text('تم جلب جميع الطلبات', style: boldStyle)),
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

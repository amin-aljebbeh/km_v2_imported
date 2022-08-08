import 'package:flutter/material.dart';
import 'package:kammun_app/modules/orders/redux/orders_action.dart';
import 'package:intl/intl.dart';
import '../../../core/core_importer.dart';

class OrdersView extends StatefulWidget {
  static const String routeName = '/OrdersView';
  const OrdersView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrdersViewState();
  }
}

class OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(NoError());
      StoreProvider.of<AppState>(context).dispatch(GetOrders());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Center(child: Text('الطلبات', style: decisionButtonStyle)),
            ),
            backgroundColor: ColorUtils.kmColors,
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15),
                child: IconButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(OrdersFetchedSuccessfully(orders: []));
                    StoreProvider.of<AppState>(context).dispatch(GetOrders());
                  },
                  icon: const Icon(Icons.refresh, size: 40, color: Colors.white),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 10),
              child: state.loadingState.isLoading && state.ordersState.orders.isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (state.ordersState.orders.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                            child: Center(
                              child: Text(
                                'لا يوجد أي طلبات سابقة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamily,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.ordersState.orders.length,
                              itemBuilder: (BuildContext context, int index) {
                                String dateTime =
                                    DateFormat('kk:mm - yyyy-MM-dd').format(state.ordersState.orders[index].createdAt);
                                return OrdersViewCard(
                                  index: index,
                                  order: state.ordersState.orders[index],
                                  underUpdate: int.parse(state.ordersState.orders[index].underUpdate),
                                  orderStatus: int.parse(state.ordersState.orders[index].orderStatusId),
                                  orderCreatedDate: dateTime,
                                  lastOrder: index == state.ordersState.orders.length - 1,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

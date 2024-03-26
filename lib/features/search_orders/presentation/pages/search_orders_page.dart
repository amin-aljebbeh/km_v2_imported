import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_action.dart';
import 'package:kammun_app/features/search_orders/presentation/widgets/search_orders_filter_widget.dart';

import '../../../../core/core_importer.dart';
import '../widgets/search_order_widget.dart';

class SearchOrdersPage extends StatelessWidget {
  const SearchOrdersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          onPop: () {
            store.dispatch(SetSearchStatusFilter(filter: 0));
            store.dispatch(SetSearchPage(page: 1));
            Navigator.push(context, MaterialPageRoute(builder: (screenContext) =>  const HomePage()));
            },
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
                    const SearchOrdersFilterWidget(),
                    state.loadingState.loading.isNotEmpty
                        ? const Center(child: Loader())
                        : state.searchOrdersState.orders.isEmpty
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
                        itemCount: state.searchOrdersState.orders == null ? 0 : state.searchOrdersState.orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (!Services.hasRole(context, supplierRole) &&
                              (Services.hasRole(context, shopperRole) ||
                                  state.searchOrdersState.orders[index].shopper != null)) {
                            state.searchOrdersState.orders[index].orderArithmeticOperations(context);
                            state.searchOrdersState.orders[index].orderProfits(context: context);
                          }
                          return SearchOrderWidget(order: state.searchOrdersState.orders[index]);
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

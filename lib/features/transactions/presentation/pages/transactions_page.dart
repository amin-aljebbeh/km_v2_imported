import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';
import '../widgets/transaction_widget.dart';

class TransactionsPage extends StatelessWidget {
  static String routeName = '/TransactionsPage';

  const TransactionsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('المناقلات', style: appBarStyle)),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  state.loadingState.isLoading
                      ? const Center(child: Loader())
                      : state.errorState.isError && state.transactionsState.transactions.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : state.transactionsState.transactions.isEmpty && !state.loadingState.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('لا يوجد طلبات', style: paragraphStyle)))
                              : Expanded(
                                  child: NotificationListener<ScrollEndNotification>(
                                    onNotification: (ScrollEndNotification scrollInfo) {
                                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                          state.transactionsState.hasNextRequests) {
                                        StoreProvider.of<AppState>(context).dispatch(NextTransactionRequestsPage());
                                        StoreProvider.of<AppState>(context).dispatch(GetTransactionRequestsAction());
                                      }
                                      return;
                                    },
                                    child: ListView.builder(
                                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                        primary: false,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: state.transactionsState.transactions.length,
                                        itemBuilder: (BuildContext context, int index) => TransactionWidget(
                                            transactionEntity: state.transactionsState.transactions[index])),
                                  ),
                                ),
                  if (!state.transactionsState.hasNextRequests && !state.loadingState.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('تم عرض جميع المناقلات', style: paragraphStyle)),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

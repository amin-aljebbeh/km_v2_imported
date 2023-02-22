import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';
import 'package:kammun_app/features/transactions/presentation/widgets/transaction_request_widget.dart';

import '../../../../core/core_importer.dart';

class TransactionRequestsPage extends StatelessWidget {
  const TransactionRequestsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  state.loadingState.isLoading
                      ? const Center(child: Loader())
                      : state.errorState.isError && state.transactionsState.requests.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : state.transactionsState.requests.isEmpty && !state.loadingState.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('ليس لديك أكواد حسم', style: paragraphStyle)))
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
                                        itemCount: state.transactionsState.requests.length,
                                        itemBuilder: (BuildContext context, int index) => TransactionRequestWidget(
                                            transactionRequestEntity: state.transactionsState.requests[index])),
                                  ),
                                ),
                  if (!state.transactionsState.hasNextRequests && !state.loadingState.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('تم عرض جميع الطلبات', style: paragraphStyle)),
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

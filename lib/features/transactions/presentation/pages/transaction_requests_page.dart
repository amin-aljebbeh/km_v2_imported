import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';
import 'package:kammun_app/features/transactions/presentation/widgets/transaction_request_widget.dart';

import '../../../../core/core_importer.dart';

class TransactionRequestsPage extends StatefulWidget {
  static String routeName = '/TransactionRequestsPage';

  const TransactionRequestsPage({Key key}) : super(key: key);

  @override
  _TransactionRequestsPageState createState() => _TransactionRequestsPageState();
}

class _TransactionRequestsPageState extends State<TransactionRequestsPage> {
  List<String> statuses = ['معلق', 'مقبول', 'مرفوض'];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<DropdownMenuItem<int>> categories = state.transactionsState.filterCategories
            .map((category) => DropdownMenuItem<int>(
                child: AutoSizeText(category.name, style: mainStyle, maxFontSize: 15), value: category.id))
            .toList();
        categories.add(DropdownMenuItem<int>(child: Text('الكل', style: mainStyle), value: null));
        List<DropdownMenuItem<int>> items = statuses
            .map((status) => DropdownMenuItem<int>(
                child: AutoSizeText(status, style: mainStyle), value: statuses.indexOf(status) + 1))
            .toList();
        items.add(DropdownMenuItem<int>(child: Text('الكل', style: mainStyle), value: null));
        return TemporaryLoading(
          child: Scaffold(
            appBar: AppBar(backgroundColor: primaryColor, title: Text('طلبات المناقلات', style: appBarStyle), actions: [
              IconButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(RefreshRequests());
                    StoreProvider.of<AppState>(context).dispatch(GetTransactionRequestsAction());
                  },
                  icon: const Icon(Icons.refresh, size: 35))
            ]),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                  value: state.transactionsState.createdByMe == 1,
                                  onChanged: (bool value) {
                                    StoreProvider.of<AppState>(context).dispatch(FirstRequestsPage());
                                    if (value) {
                                      StoreProvider.of<AppState>(context).dispatch(SetCreatedByMe(createdByMe: 1));
                                    } else {
                                      StoreProvider.of<AppState>(context).dispatch(SetCreatedByMe(createdByMe: 0));
                                    }
                                    StoreProvider.of<AppState>(context).dispatch(GetTransactionRequestsAction());
                                  },
                                  activeColor: primaryColor),
                              Text('أنا أنشأتها', style: decisionButtonStyle.copyWith(color: Colors.black)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                  value: state.transactionsState.assignedToMe == 1,
                                  onChanged: (bool value) {
                                    StoreProvider.of<AppState>(context).dispatch(FirstRequestsPage());
                                    if (value) {
                                      StoreProvider.of<AppState>(context).dispatch(SetAssignedToMe(assignedToMe: 1));
                                    } else {
                                      StoreProvider.of<AppState>(context).dispatch(SetAssignedToMe(assignedToMe: 0));
                                    }
                                    StoreProvider.of<AppState>(context).dispatch(GetTransactionRequestsAction());
                                  },
                                  activeColor: primaryColor),
                              Text('مسندة لي', style: decisionButtonStyle.copyWith(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton(
                            items: categories,
                            hint: Text('نوع المناقلة', style: mainStyle),
                            value: state.transactionsState.transactionCategoryId,
                            onChanged: (value) {
                              StoreProvider.of<AppState>(context).dispatch(FirstRequestsPage());
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetTransactionCategoryId(transactionCategoryId: value));
                              StoreProvider.of<AppState>(context).dispatch(GetTransactionRequestsAction());
                              setState(() {});
                            }),
                        DropdownButton(
                            items: items,
                            hint: Text('حالة الطلب', style: mainStyle),
                            value: state.transactionsState.transactionStatusId,
                            onChanged: (value) {
                              StoreProvider.of<AppState>(context).dispatch(FirstRequestsPage());
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetTransactionStatusId(transactionStatusId: value));
                              StoreProvider.of<AppState>(context).dispatch(GetTransactionRequestsAction());
                              setState(() {});
                            })
                      ],
                    ),
                  ),
                  state.loadingState.loading.isNotEmpty
                      ? const Center(child: Loader())
                      : state.errorState.isError && state.transactionsState.requests.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : state.transactionsState.requests.isEmpty && state.loadingState.loading.isEmpty
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
                                        itemCount: state.transactionsState.requests.length,
                                        itemBuilder: (BuildContext context, int index) => TransactionRequestWidget(
                                            transactionRequestEntity: state.transactionsState.requests[index])),
                                  ),
                                ),
                  if (!state.transactionsState.hasNextRequests &&
                      state.loadingState.loading.isEmpty &&
                      state.transactionsState.requests.isNotEmpty)
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

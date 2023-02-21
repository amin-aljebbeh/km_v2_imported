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
                      : state.errorState.isError && state.couponState.coupons.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(state.errorState.errorMessage, style: paragraphStyle)))
                          : state.couponState.coupons.isEmpty && !state.loadingState.isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('ليس لديك أكواد حسم', style: paragraphStyle)))
                              : Expanded(
                                  child: NotificationListener<ScrollEndNotification>(
                                    onNotification: (ScrollEndNotification scrollInfo) {
                                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                                          state.couponState.hasNext) {
                                        // StoreProvider.of<AppState>(context).dispatch(NextCouponsPage());
                                        // StoreProvider.of<AppState>(context).dispatch(GetCouponsAction(
                                        //     code: controller.text, isForDelivery: [0, 1].contains(type) ? type : null));
                                      }
                                      return;
                                    },
                                    child: ListView.builder(
                                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                        primary: false,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: state.couponState.coupons.length,
                                        itemBuilder: (BuildContext context, int index) => Container()),
                                  ),
                                ),
                  if (!state.couponState.hasNext && !state.loadingState.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('تم جلب جميع الأكواد', style: paragraphStyle)),
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

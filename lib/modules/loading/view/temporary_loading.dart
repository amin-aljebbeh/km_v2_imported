import 'package:flutter/material.dart';
import '../../invoice/redux/invoice_action.dart';
import '../../../core/core_importer.dart';

class TemporaryLoading extends StatelessWidget {
  final Widget child;
  final bool condition;
  final bool pop;
  const TemporaryLoading({Key key, this.child, this.condition = true, this.pop = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => !state.loadingState.isLoading && pop,
          child: Stack(
            children: [
              child,
              if (state.loadingState.isLoading && condition)
                const Scaffold(body: Center(child: Loader()), backgroundColor: Colors.white60),
              if (state.errorState.isError && state.errorState.viewError)
                Scaffold(
                  body: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(NoError()),
                        ),
                        AlertMessages(
                          text: state.errorState.errorMessage,
                          messageType: 'internetError',
                          headerText: 'حدث خطأ',
                        ),
                        if (state.cartState.showCancelCoupon)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KOutlinedButton(
                              width: MediaQuery.of(context).size.width,
                              text: 'إلغاء كود الحسم',
                              height: 50,
                              color: Colors.red,
                              onTap: () {
                                StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(NoError());
                                StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
                                StoreProvider.of<AppState>(navigatorKey.currentContext)
                                    .dispatch(CancelCoupon(orderId: state.ordersState.updatedOrderId.toString()));
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.white60,
                ),
            ],
          ),
        );
      },
    );
  }
}

import '../../../../core/core_importer.dart';

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
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Container()),
                      Center(child: AlertMessages(text: state.errorState.errorMessage, messageType: 'internetError')),
                      Expanded(child: Container()),
                    ],
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

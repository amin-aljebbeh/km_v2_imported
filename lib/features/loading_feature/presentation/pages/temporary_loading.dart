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
          onWillPop: () async => !state.loadingState.loading.isNotEmpty && pop,
          child: Stack(
            children: [
              child,
              if (state.loadingState.loading.isNotEmpty && condition)
                const Scaffold(body: Center(child: Loader()), backgroundColor: Colors.white60),
              if ((state.errorState.isError && state.errorState.viewError) || state.loadingState.viewMessage)
                Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Container()),
                      Center(
                          child: AlertMessages(
                              text:
                                  state.errorState.isError ? state.errorState.errorMessage : state.loadingState.message,
                              messageType: state.errorState.isError ? 'internetError' : 'Successfully')),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: KammunButton(
                            color: state.errorState.isError ? Colors.red : Colors.green[800],
                            onTap: () {
                              StoreProvider.of<AppState>(context).dispatch(NoError());
                              StoreProvider.of<AppState>(context).dispatch(HideMessage());
                            },
                            width: MediaQuery.of(context).size.width,
                            text: closeString,
                            height: 50),
                      ),
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

import '../../../../core/core_importer.dart';

class TemporaryLoading extends StatelessWidget {
  final Widget child;
  final bool condition;
  final Function onPop;

  const TemporaryLoading({Key key, this.child, this.condition = true, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (onPop != null) onPop();
            if (!state.loadingState.loading.isNotEmpty) StoreProvider.of<AppState>(context).dispatch(NoError());
            return !state.loadingState.loading.isNotEmpty;
          },
          child: Stack(
            children: [
              child,
              if (state.loadingState.loading.isNotEmpty && condition)
                const Scaffold(body: Center(child: Loader()), backgroundColor: Colors.white60),
              if (state.errorState.isError && state.errorState.viewError)
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
                            color: Colors.red,
                            onTap: () => StoreProvider.of<AppState>(context).dispatch(NoError()),
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

import '../../../../core/core_importer.dart';

class AddTransactionRequestPage extends StatelessWidget {
  const AddTransactionRequestPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Container();
      },
    );
  }
}

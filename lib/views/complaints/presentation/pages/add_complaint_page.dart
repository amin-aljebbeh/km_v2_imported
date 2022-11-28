import 'package:kammun_app/views/loading_feature/presentation/pages/temporary_loading.dart';

import '../../../../core/core_importer.dart';

class AddComplaintPage extends StatelessWidget {
  const AddComplaintPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('إضافة شكوى', style: mainStyle)),
          body: TemporaryLoading(
            child: SafeArea(
              child: Container(),
            ),
          ),
        );
      },
    );
  }
}

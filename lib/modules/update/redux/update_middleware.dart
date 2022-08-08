import 'package:kammun_app/modules/update/redux/update_action.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/core_importer.dart';

Future<void> updateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is LaunchUpdate) {
    if (await canLaunch(store.state.updateState.updateUrl)) {
      await launch(store.state.updateState.updateUrl);
      store.dispatch(NoError());
    } else {
      store.dispatch(CatchError(errorMessage: 'فشل طلب تحديث التطبيق'));
    }
  }
  next(action);
}

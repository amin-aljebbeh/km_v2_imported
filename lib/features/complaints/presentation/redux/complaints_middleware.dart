import '../../../../core/core_importer.dart';
import 'complaints_action.dart';

Future<void> complaintsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ComplaintsAction) action.handle(store: store);
  next(action);
}

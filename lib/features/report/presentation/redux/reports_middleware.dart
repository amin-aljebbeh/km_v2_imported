import '../../../../core/core_importer.dart';
import 'reports_action.dart';

Future<void> reportsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ReportsAction) action.handle(store: store, state: store.state.reportState);
  next(action);
}

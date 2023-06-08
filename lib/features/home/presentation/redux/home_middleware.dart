import '../../../../core/core_importer.dart';
import 'home_action.dart';

Future<void> homeMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is HomeAction) await action.handle(store: store);
  next(action);
}

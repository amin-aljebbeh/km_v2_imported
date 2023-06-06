import '../../../../core/core_importer.dart';
import 'cart_action.dart';

Future<void> cartMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is CartAction) action.handle(store: store);
  next(action);
}

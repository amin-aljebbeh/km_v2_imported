import '../../../../core/core_importer.dart';
import 'order_details_action.dart';

Future<void> orderDetailsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is OrderDetailsAction) action.handle(store: store);
  next(action);
}

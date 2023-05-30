import 'package:kammun_app/features/search_orders/presentation/redux/search_orders_action.dart';

import '../../../../core/core_importer.dart';

Future<void> searchOrdersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SearchOrdersAction) action.handle(store: store);
  next(action);
}

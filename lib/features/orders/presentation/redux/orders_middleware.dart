import 'package:kammun_app/features/orders/presentation/redux/orders_action.dart';

import '../../../../core/core_importer.dart';

Future<void> ordersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is OrdersAction) action.handle(store: store);
  next(action);
}

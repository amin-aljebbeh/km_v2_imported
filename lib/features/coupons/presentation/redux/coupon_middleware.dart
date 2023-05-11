import '../../../../core/core_importer.dart';
import 'coupon_action.dart';

Future<void> couponMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is CouponsAction) await action.handle(store: store);
  next(action);
}

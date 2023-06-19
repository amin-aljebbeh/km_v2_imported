import '../../../../core/core_importer.dart';
import 'inventory_action.dart';

Future<void> inventoryMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is InventoryAction) await action.handle(store: store);
  next(action);
}

import '../../../../core/core_importer.dart';
import 'inventory_file_action.dart';

Future<void> inventoryFileMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is InventoryFileAction) await action.handle(store: store, state: store.state.excelInventoryState);
  next(action);
}

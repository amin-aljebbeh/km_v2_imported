import '../../../../core/core_importer.dart';
import 'excel_inventory_action.dart';

Future<void> excelInventoryMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ExcelInventoryAction) await action.handle(store: store, state: store.state.excelInventoryState);
  next(action);
}

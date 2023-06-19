import '../../../../core/core_importer.dart';
import 'sub_warehouse_manager_action.dart';

Future<void> subWarehouseManagerMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SubWarehouseManagerAction) await action.handle(store: store, state: store.state.excelInventoryState);
  next(action);
}

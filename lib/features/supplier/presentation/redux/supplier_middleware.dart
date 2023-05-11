import '../../../../core/core_importer.dart';
import 'supplier_action.dart';

Future<void> supplierMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SupplierAction) action.handle(store: store);
  next(action);
}

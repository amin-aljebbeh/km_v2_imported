import '../../../../core/core_importer.dart';
import 'barcode_action.dart';

Future<void> barcodeMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is BarcodeAction) action.handle(store: store);
  next(action);
}

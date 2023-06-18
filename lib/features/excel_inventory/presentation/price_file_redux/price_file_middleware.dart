import '../../../../core/core_importer.dart';
import 'price_file_action.dart';

Future<void> priceFileMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is PriceFileAction) await action.handle(store: store, state: store.state.excelInventoryState);
  next(action);
}

import '../../../../core/core_importer.dart';
import 'products_filter_action.dart';

Future<void> productsFilterMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ProductsFilterAction) action.handle(store: store);
  next(action);
}

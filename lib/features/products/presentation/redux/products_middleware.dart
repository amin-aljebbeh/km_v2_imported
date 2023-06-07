import 'package:kammun_app/features/products/presentation/redux/products_action.dart';

import '../../../../core/core_importer.dart';

Future<void> productsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ProductsAction) action.handle(store: store);
  next(action);
}

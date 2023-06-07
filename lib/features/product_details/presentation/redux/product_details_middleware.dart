import 'package:kammun_app/features/product_details/presentation/redux/product_details_action.dart';

import '../../../../core/core_importer.dart';

Future<void> productDetailsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is ProductDetailsAction) action.handle(store: store);
  next(action);
}

import 'package:kammun_app/features/transactions/presentation/redux/transactions_action.dart';

import '../../../../core/core_importer.dart';

Future<void> transactionsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is TransactionsAction) action.handle(store: store);
  next(action);
}

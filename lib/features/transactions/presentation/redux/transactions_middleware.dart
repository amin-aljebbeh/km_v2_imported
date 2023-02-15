import '../../../../core/core_importer.dart';

Future<void> transactionsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
}


import '../../../../core/core_importer.dart';

Future<void> loadingMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
}

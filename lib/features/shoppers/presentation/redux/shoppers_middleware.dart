import '../../../../core/core_importer.dart';

Future<void> shoppersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
}

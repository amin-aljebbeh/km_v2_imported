import '../../../../core/core_importer.dart';

Future<void> errorMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
}

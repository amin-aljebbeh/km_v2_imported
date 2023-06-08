import '../../../../core/core_importer.dart';

Future<void> generalInformationMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
}

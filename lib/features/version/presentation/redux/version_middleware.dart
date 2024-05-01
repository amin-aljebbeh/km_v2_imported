import 'package:kammun_app/features/version/presentation/redux/version_action.dart';

import '../../../../core/core_importer.dart';

Future<void> versionMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is VersionAction) action.handle(store: store);
  next(action);
}

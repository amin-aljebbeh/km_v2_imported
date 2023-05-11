import 'package:kammun_app/features/admins/presentation/redux/admins_action.dart';

import '../../../../core/core_importer.dart';

Future<void> adminsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is AdminsAction) await action.handle(store: store);
  next(action);
}

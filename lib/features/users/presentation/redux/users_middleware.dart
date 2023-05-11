import 'package:kammun_app/features/users/presentation/redux/users_action.dart';

import '../../../../core/core_importer.dart';

Future<void> usersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is UsersAction) action.handle(store: store);
  next(action);
}

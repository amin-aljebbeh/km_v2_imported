import 'package:kammun_app/features/todos/presentation/redux/todos_action.dart';

import '../../../../core/core_importer.dart';

Future<void> todosMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is TodosAction) action.handle(store: store);
  next(action);
}

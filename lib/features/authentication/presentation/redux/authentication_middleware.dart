import '../../../../core/core_importer.dart';
import 'authentication_action.dart';

Future<void> authenticationMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is AuthenticationAction) action.handle(store: store, state: store.state.authenticationState);
  next(action);
}

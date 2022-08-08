import 'package:kammun_app/core/core_importer.dart';
import '../services/error_services.dart';

Future<void> errorMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is CatchError) {
    int userId;
    if (store.state.startupState.startModel != null) {
      userId = store.state.startupState.startModel.user.id;
    } else if (store.state.authenticationState.userId != 0) {
      userId = store.state.authenticationState.userId;
    }
    await ErrorServices.logUserError(
      url: store.state.errorState.url,
      statusCode: store.state.errorState.statusCode,
      reason: action.reason ?? action.errorMessage,
      userId: userId,
    );
    store.dispatch(StopLoading());
  }
  next(action);
}

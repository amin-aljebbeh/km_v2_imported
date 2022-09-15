import 'app_middleware.dart';
import 'app_reducer.dart';
import 'app_state.dart';

import 'package:redux/redux.dart';

class AppRedux {
  static Store<AppState> init() =>
      Store<AppState>(appReducer, initialState: AppState.initial(), distinct: true, middleware: appMiddleware());
}

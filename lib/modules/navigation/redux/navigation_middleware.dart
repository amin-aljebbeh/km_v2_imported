import '../../../core/core_importer.dart';

List<Middleware<AppState>> createNavigationMiddleware() {
  return [
    TypedMiddleware<AppState, PushAndReplace>(_navigateReplace),
    TypedMiddleware<AppState, Push>(_navigate),
    TypedMiddleware<AppState, Pop>(_navigatePop),
  ];
}

_navigateReplace(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as PushAndReplace).routeName;
  navigatorKey.currentState.pushReplacementNamed(routeName);
  next(action);
}

_navigate(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as Push).routeName;
  navigatorKey.currentState.pushNamed(routeName);
  next(action);
}

_navigatePop(Store<AppState> store, action, NextDispatcher next) {
  final returnValue = (action as Pop).returnValue;

  navigatorKey.currentState.pop(returnValue);
  next(action);
}

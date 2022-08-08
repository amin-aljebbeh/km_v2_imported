import '../../../core/core_importer.dart';
import '../models/navigation_model.dart';
import 'navigation_state.dart';

final navigationReducer = combineReducers<NavigationState>([
  TypedReducer<NavigationState, PushAndReplace>(navigateReplace),
  TypedReducer<NavigationState, Push>(navigatePush),
  TypedReducer<NavigationState, Pop>(navigatePop),
]);

NavigationState navigateReplace(NavigationState state, PushAndReplace action) {
  List<NavigationModel> routes = state.routes.toList();
  if (routes.isNotEmpty) {
    routes.removeLast();
    routes.add(NavigationModel(routeName: action.routeName, arguments: action.arguments));
  }
  return state.copyWith(routes: routes);
}

NavigationState navigatePush(NavigationState state, Push action) {
  List<NavigationModel> routes = state.routes.toList();

  routes.add(NavigationModel(routeName: action.routeName, arguments: action.arguments));

  return state.copyWith(routes: routes);
}

NavigationState navigatePop(NavigationState state, Pop action) {
  List<NavigationModel> routes = state.routes.toList();
  if (routes.isNotEmpty) {
    routes.removeLast();
  }
  return state.copyWith(routes: routes);
}

import '../../../core/core_importer.dart';
import 'loading_state.dart';

final loadingReducer = combineReducers<LoadingState>([
  TypedReducer<LoadingState, InitialLoading>(initialLoading),
  TypedReducer<LoadingState, StartLoading>(startLoading),
  TypedReducer<LoadingState, StopLoading>(stopLoading),
]);

LoadingState initialLoading(LoadingState state, InitialLoading action) {
  return LoadingState.initial();
}

LoadingState startLoading(LoadingState state, StartLoading action) {
  return state.copyWith(isLoading: true);
}

LoadingState stopLoading(LoadingState state, StopLoading action) {
  return state.copyWith(isLoading: false);
}

import '../../../../core/core_importer.dart';
import 'loading_state.dart';

final loadingReducer = combineReducers<LoadingState>([
  TypedReducer<LoadingState, InitialLoading>(initialLoading),
  TypedReducer<LoadingState, StartLoading>(startLoading),
  TypedReducer<LoadingState, StopLoading>(stopLoading),
]);

LoadingState initialLoading(LoadingState state, InitialLoading action) => LoadingState.initial();

LoadingState startLoading(LoadingState state, StartLoading action) {
  List<int> loading = [];
  loading.addAll(state.loading);
  loading.add(1);
  return state.copyWith(loading: loading);
}

LoadingState stopLoading(LoadingState state, StopLoading action) {
  List<int> loading = [];
  loading.addAll(state.loading);
  if (loading.isNotEmpty) loading.removeLast();
  return state.copyWith(loading: loading);
}

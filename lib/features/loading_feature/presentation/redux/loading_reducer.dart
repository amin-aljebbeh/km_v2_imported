import '../../../../core/core_importer.dart';
import 'loading_state.dart';

final loadingReducer = combineReducers<LoadingState>([
  TypedReducer<LoadingState, InitialLoading>(initialLoading),
  TypedReducer<LoadingState, StartLoading>(startLoading),
  TypedReducer<LoadingState, StopLoading>(stopLoading),
  TypedReducer<LoadingState, ViewMessage>(viewMessage),
  TypedReducer<LoadingState, HideMessage>(hideMessage),
]);

LoadingState initialLoading(LoadingState state, InitialLoading action) => LoadingState.initial();

LoadingState startLoading(LoadingState state, StartLoading action) => state.copyWith(isLoading: true);

LoadingState stopLoading(LoadingState state, StopLoading action) => state.copyWith(isLoading: false);

LoadingState viewMessage(LoadingState state, ViewMessage action) =>
    state.copyWith(viewMessage: true, message: action.message);

LoadingState hideMessage(LoadingState state, HideMessage action) => state.copyWith(viewMessage: false);

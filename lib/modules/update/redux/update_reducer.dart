import '../../../core/core_importer.dart';
import 'update_action.dart';
import 'update_state.dart';

Reducer<UpdateState> updateReducer = combineReducers<UpdateState>([
  TypedReducer<UpdateState, RequiredUpdate>(requiredUpdate),
  TypedReducer<UpdateState, OptionalUpdate>(optionalUpdate),
  TypedReducer<UpdateState, SetUpdateUrl>(setUpdateUrl),
]);

UpdateState requiredUpdate(UpdateState state, RequiredUpdate action) {
  return state.copyWith(optionalUpdate: false, requiredUpdate: true);
}

UpdateState optionalUpdate(UpdateState state, OptionalUpdate action) {
  return state.copyWith(optionalUpdate: true, requiredUpdate: false);
}

UpdateState setUpdateUrl(UpdateState state, SetUpdateUrl action) {
  return state.copyWith(updateUrl: action.updateUrl);
}

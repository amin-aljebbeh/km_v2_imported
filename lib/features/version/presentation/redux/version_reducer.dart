import '../../../../core/core_importer.dart';
import 'version_action.dart';
import 'version_state.dart';

Reducer<VersionState> versionReducer = combineReducers<VersionState>([
  TypedReducer<VersionState, SetVersionStatus>(setVersionStatus),
]);

VersionState setVersionStatus(VersionState state, SetVersionStatus action) =>
    state.copyWith(validVersion: action.versionStatus);

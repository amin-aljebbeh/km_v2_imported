import 'package:kammun_app/features/admins/presentation/redux/admins_state.dart';

import '../../../../core/core_importer.dart';
import 'admins_action.dart';

Reducer<AdminsState> adminsReducer = combineReducers<AdminsState>([
  TypedReducer<AdminsState, SetAdmins>(setAdmins),
]);

AdminsState setAdmins(AdminsState state, SetAdmins action) {
  return state.copyWith(admins: action.admins);
}

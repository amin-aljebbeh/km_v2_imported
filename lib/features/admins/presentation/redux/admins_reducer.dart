import 'package:kammun_app/features/admins/presentation/redux/admins_state.dart';

import '../../../../core/core_importer.dart';
import 'admins_action.dart';

Reducer<AdminsState> adminsReducer = combineReducers<AdminsState>([
  TypedReducer<AdminsState, SetAdmins>(setAdmins),
  TypedReducer<AdminsState, SetAdmin>(setAdmin),
  TypedReducer<AdminsState, SetTransactionsActors>(transactionsActors),
]);

AdminsState setAdmins(AdminsState state, SetAdmins action) {
  return state.copyWith(admins: action.admins);
}

AdminsState setAdmin(AdminsState state, SetAdmin action) {
  return state.copyWith(admin: action.admin);
}

AdminsState transactionsActors(AdminsState state, SetTransactionsActors action) {
  return state.copyWith(transactionsActors: action.admins);
}

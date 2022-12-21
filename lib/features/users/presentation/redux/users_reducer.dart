import 'package:kammun_app/features/users/presentation/redux/users_state.dart';
import '../../../../core/core_importer.dart';
import 'users_action.dart';

Reducer<UsersState> usersReducer = combineReducers<UsersState>([TypedReducer<UsersState, SetUser>(setUser)]);

UsersState setUser(UsersState state, SetUser action) => state.copyWith(userEntity: action.userEntity);

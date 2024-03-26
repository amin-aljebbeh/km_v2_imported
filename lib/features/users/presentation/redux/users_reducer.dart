import 'package:kammun_app/features/users/presentation/redux/users_state.dart';
import '../../../../core/core_importer.dart';
import 'users_action.dart';

Reducer<UsersState> usersReducer = combineReducers<UsersState>([TypedReducer<UsersState, SetUser>(setUser),TypedReducer<UsersState, SetBalance>(setBalance),]  );

UsersState setUser(UsersState state, SetUser action) => state.copyWith(userEntity: action.userEntity);
UsersState setBalance(UsersState state, SetBalance action) => state.copyWith(balance: action.balance);

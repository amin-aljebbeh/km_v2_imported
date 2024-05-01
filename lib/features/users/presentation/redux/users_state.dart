import 'package:kammun_app/features/users/domain/use_cases/users_use_cases.dart';

import '../../../../core/core_importer.dart';
import '../../data/models/balance_model.dart';
import '../../domain/entities/user_entity.dart';

@immutable
class UsersState extends Equatable {
  final UsersUseCases usersUseCases;
  final UserEntity userEntity;
  final BalanceModel balance;

  const UsersState({this.usersUseCases, this.userEntity, this.balance});

  factory UsersState.initial() {
    return UsersState(usersUseCases: sl<UsersUseCases>(), userEntity: null);
  }

  UsersState copyWith({UserEntity userEntity, BalanceModel balance}) {
    return UsersState(usersUseCases: usersUseCases, userEntity: userEntity, balance: balance);
  }

  @override
  List<Object> get props => [userEntity, usersUseCases, balance];
}

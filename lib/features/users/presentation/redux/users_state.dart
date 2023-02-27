import 'package:kammun_app/features/users/domain/use_cases/users_use_cases.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/user_entity.dart';

@immutable
class UsersState extends Equatable {
  final UsersUseCases usersUseCases;
  final UserEntity userEntity;

  const UsersState({this.usersUseCases, this.userEntity});

  factory UsersState.initial() {
    return UsersState(usersUseCases: sl<UsersUseCases>(), userEntity: null);
  }

  UsersState copyWith({UserEntity userEntity}) {
    return UsersState(usersUseCases: usersUseCases, userEntity: userEntity);
  }

  @override
  List<Object> get props => [userEntity, usersUseCases];
}

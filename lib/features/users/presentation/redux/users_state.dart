import 'package:kammun_app/features/users/domain/use_cases/users_use_cases.dart';

import '../../../../core/core_importer.dart';

@immutable
class UsersState extends Equatable {
  final UsersUseCases usersUseCases;
  const UsersState({this.usersUseCases});

  factory UsersState.initial() {
    return UsersState(usersUseCases: sl<UsersUseCases>());
  }

  UsersState copyWith() {
    return UsersState(usersUseCases: usersUseCases);
  }

  @override
  List<Object> get props => [];
}

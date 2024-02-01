import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../repositories/users_repository.dart';

class ChangeNumberPhoneUserUseCase {
  final UsersRepository usersRepository;

  ChangeNumberPhoneUserUseCase({this.usersRepository});

  Future<Either<Failure, Unit>> call({String phoneNumber, int userId}) async {
    return await usersRepository.changeNumberPhoneUser(userId: userId, phoneNumber: phoneNumber);
  }
}

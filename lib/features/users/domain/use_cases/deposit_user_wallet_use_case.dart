import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/users/domain/repositories/users_repository.dart';

import '../../../../core/core_importer.dart';

class DepositUserWalletUseCase {
  final UsersRepository usersRepository;

  DepositUserWalletUseCase({this.usersRepository});

  Future<Either<Failure, Unit>> call({int userId, int value, String description}) async {
    return await usersRepository.depositUserWalletToCoupon(userId: userId, value: value, description: description);
  }
}

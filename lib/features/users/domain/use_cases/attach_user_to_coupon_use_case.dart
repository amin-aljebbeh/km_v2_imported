import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../repositories/users_repository.dart';

class AttachUserToCouponUseCase {
  final UsersRepository usersRepository;

  AttachUserToCouponUseCase({this.usersRepository});

  Future<Either<Failure, Unit>> call({int couponId, int userId, int availability}) async {
    return await usersRepository.attachUserToCoupon(userId: userId, availability: availability, couponId: couponId);
  }
}

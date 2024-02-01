import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class UsersRepository {
  Future<Either<Failure, Unit>> attachUserToCoupon({int couponId, int userId, int availability});
  Future<Either<Failure, Unit>> changeNumberPhoneUser({ int userId, String phoneNumber});

}

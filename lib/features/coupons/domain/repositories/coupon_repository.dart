import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/coupon_entity.dart';

abstract class CouponsRepository {
  Future<Either<Failure, List<CouponEntity>>> getCoupons({int isGeneral, int isForDelivery, String code});
}
